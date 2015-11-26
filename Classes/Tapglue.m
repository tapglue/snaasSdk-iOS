//
//  Tapglue.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 02/06/15.
//  Copyright (c) 2015 Tapglue (https://www.tapglue.com/). All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "Tapglue+Private.h"
#import "TGApiClient.h"
#import "TGUser.h"
#import "TGEvent.h"
#import "TGEventObject.h"
#import "TGModelObject+Private.h"
#import "NSString+TGUtilities.h"
#import "TGEventManager.h"
#import "TGUserManager.h"
#import "TGObjectCache.h"
#import "TGConfiguration.h"

#import <UIKit/UIKit.h>

NSString *const TaplueSDKID = @"com.tapglue.sdk";

@interface Tapglue ()
{
    NSUInteger _flushInterval;
}
@property (nonatomic, strong) NSString *appToken;
@property (nonatomic, strong) TGApiClient* client;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) TGEventManager *eventManager;
@property (nonatomic, strong) TGUserManager *userManager;
@property (nonatomic, strong) NSTimer *flushTimer;

@end

@implementation Tapglue

#pragma mark - Setup

static Tapglue* sharedInstance = nil;

+ (void)setUpWithAppToken:(NSString *)token {
    [self setUpWithAppToken:token andConfig:nil];
}

+ (void)setUpWithAppToken:(NSString *)token andConfig:(TGConfiguration*)config {
    if (!config) { config = [TGConfiguration defaultConfiguration]; }
    sharedInstance = [[Tapglue alloc] initWithAppToken:token andConfig:config];
    if (config.isAnalyticsEnabled) {
        [sharedInstance.client pingAnalyticsEndpoint];
    }
}

- (instancetype)initWithAppToken:(NSString*)token andConfig:(TGConfiguration*)config {
    self = [super init];
    if (self) {
        self.client = [[TGApiClient alloc] initWithAppToken:token andConfig:config];
        self.client.sessionToken = [self.userDefaults valueForKey:TapglueUserDefaultsKeySessionToken];
        /*
         the event manager needs to be lazy initalized
         because it requires the the Tapglue singleton instance
         in order to get the current user for unarchiving the event queues
         which is a deadlock
        */
        // self.eventManager = [[TGEventManager alloc] initWithClient:self.client];
        self.userManager = [[TGUserManager alloc] initWithClient:self.client];
        [self registerForAppLifeCycleNotifications];

        [self loadConfig:config];

    }
    return self;
}

- (TGEventManager*)eventManager {
    if (!_eventManager) {
        _eventManager = [[TGEventManager alloc] initWithClient:self.client];
    }
    return _eventManager;
}

- (void)loadConfig:(TGConfiguration*)config {
    if (!config) {
        config = [TGConfiguration defaultConfiguration];
    }
    [TGLogger setLoggingEnabled:config.isLoggingEnabled];
    self.flushInterval = config.flushInterval;
}

+ (Tapglue *)sharedInstance {
    NSAssert(sharedInstance, @"Tapglue is not initiliazed yet. Call `[Tapglue setUpWithAppToken:]` befor.");
    return sharedInstance;
}

#pragma mark - application life cycle

- (void)registerForAppLifeCycleNotifications {

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self
                           selector:@selector(applicationDidEnterBackground:)
                               name:UIApplicationDidEnterBackgroundNotification
                             object:nil];

    [notificationCenter addObserver:self
                           selector:@selector(applicationWillTerminate:)
                               name:UIApplicationWillTerminateNotification
                             object:nil];

    [notificationCenter addObserver:self
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];

    [notificationCenter addObserver:self
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];

}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    TGLog(@"%@ application did become active", self);
    [self startFlushTimer];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    TGLog(@"%@ application will resign active", self);
    [self stopFlushTimer];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    // TODO: consider moving flush to a background task
    [self flush];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
//    dispatch_async(_serialQueue, ^{
//        [[self sharedInstance].eventManager archive];
//    });
    [self archive];
}

- (void)flush {
    [self.eventManager flush];
}

- (void)archive {
    [self.eventManager archive];
}

#pragma mark - Flush Timer

- (NSUInteger)flushInterval {
    @synchronized(self) {
        return _flushInterval;
    }
}

- (void)setFlushInterval:(NSUInteger)interval
{
    @synchronized(self) {
        _flushInterval = interval;
    }
    [self startFlushTimer];
}

- (void)startFlushTimer
{
    [self stopFlushTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.flushInterval > 0) {
            self.flushTimer = [NSTimer scheduledTimerWithTimeInterval:self.flushInterval
                                                               target:self
                                                             selector:@selector(flush)
                                                             userInfo:nil
                                                              repeats:YES];
            TGLog(@"started flush timer with interval of %ld seconds", self.flushInterval);
        }
    });
}

- (void)stopFlushTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.flushTimer) {
            [self.flushTimer invalidate];
            TGLog(@"stopped flush timer");
        }
        self.flushTimer = nil;
    });
}

#pragma mark - User Management

#pragma mark   Current User

+ (void)createAndLoginUserWithUsername:(NSString*)username
                           andPassword:(NSString*)password
                   withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    TGUser *newUser = [[TGUser alloc] init];
    newUser.username = username;
    [newUser setPassword:password];
    [self createAndLoginUser:newUser withCompletionBlock:completionBlock];
}

+ (void)createAndLoginUserWithEmail:(NSString*)email
                        andPassword:(NSString*)password
                withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    TGUser *newUser = [[TGUser alloc] init];
    newUser.email = email;
    [newUser setPassword:password];
    [self createAndLoginUser:newUser withCompletionBlock:completionBlock];
}

+ (void)createAndLoginUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager createAndLoginUser:user withCompletionBlock:completionBlock];
}

+ (void)updateUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager updateUser:user withCompletionBlock:completionBlock];
}

+ (void)deleteCurrentUserWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager deleteCurrentUserWithCompletionBlock:completionBlock];
}

+ (void)loginWithUsernameOrEmail:(NSString *)usernameOrEmail
                     andPasswort:(NSString *)password
             withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager loginWithUsernameOrEmail:usernameOrEmail
                                                    andPasswort:password
                                            withCompletionBlock:completionBlock];
}

+ (void)retrieveCurrentUserWithCompletionBlock:(TGGetUserCompletionBlock)completionBlock {
    [[self sharedInstance].userManager retrieveCurrentUserWithCompletionBlock:completionBlock];
}

+ (void)logoutWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager logoutWithCompletionBlock:completionBlock];
}

#pragma mark   Other users

+ (void)retrieveUserWithId:(NSString*)userId withCompletionBlock:(TGGetUserCompletionBlock)completionBlock {
    [[self sharedInstance].userManager retrieveUserWithId:userId withCompletionBlock:completionBlock];
}

+ (void)searchUsersWithTerm:(NSString*)term
                 andCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    [[self sharedInstance].userManager searchUsersWithSearchString:term andCompletionBlock:completionBlock];
}

#pragma mark - Feed

+ (void)retrieveFeedForCurrentUserWithCompletionBlock:(TGFeedCompletionBlock)completionBlock {
    [[self sharedInstance].eventManager retrieveFeedForCurrentUserOnlyUnread:NO withCompletionBlock:completionBlock];
}

+ (void)retrieveUnreadFeedForCurrentUserWithCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    [[self sharedInstance].eventManager retrieveFeedForCurrentUserOnlyUnread:YES withCompletionBlock:^(NSArray *events, NSInteger unreadCount, NSError *error) {
        if (completionBlock) {
            completionBlock(events, error);
        }
    }];
}

+ (void)retrieveUnreadCountForCurrentWithCompletionBlock:(void (^)(NSInteger, NSError *))completionBlock {
    [[self sharedInstance].eventManager retrieveFeedUnreadCountForCurrentWithCompletionBlock:completionBlock];
}

+ (NSArray*)cachedFeedForCurrentUser {
    return [self sharedInstance].eventManager.cachedFeed;
}

+ (NSArray*)cachedUnreadFeedForCurrentUser {
    return [self sharedInstance].eventManager.cachedUnreadFeed;
}

+ (NSInteger)cachedUnreadCountForCurrentUser {
    return [self sharedInstance].eventManager.unreadCount;
}

#pragma mark - Connections

+ (void)followUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self followUser:user createEvent:NO withCompletionBlock:completionBlock];
}

+ (void)followUser:(TGUser*)user createEvent:(BOOL)createEvent withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager createConnectionOfType:TGConnectionTypeFollow
                                                       toUser:user
                                                    withEvent:createEvent
                                          withCompletionBlock:completionBlock];
}

+ (void)unfollowUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager deleteConnectionOfType:TGConnectionTypeFollow toUser:user withCompletionBlock:completionBlock];
}

+ (void)friendUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self friendUser:user createEvent:NO withCompletionBlock:completionBlock];
}

+ (void)friendUser:(TGUser*)user createEvent:(BOOL)createEvent withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager createConnectionOfType:TGConnectionTypeFriend
                                                       toUser:user
                                                    withEvent:createEvent
                                          withCompletionBlock:completionBlock];
}

+ (void)unfriendUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager deleteConnectionOfType:TGConnectionTypeFriend toUser:user withCompletionBlock:completionBlock];
}

+ (void)retrieveFollowsForCurrentUserWithCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    [[self sharedInstance].userManager retrieveConnectedUsersOfConnectionType:TGConnectionTypeFollow forUser:nil withCompletionBlock:completionBlock];
}

+ (void)retrieveFollowersForCurrentUserWithCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    [[self sharedInstance].userManager retrieveConnectedUsersOfConnectionType:TGConnectionTypeFollowers forUser:nil withCompletionBlock:completionBlock];
}

+ (void)retrieveFriendsForCurrentUserWithCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    [[self sharedInstance].userManager retrieveConnectedUsersOfConnectionType:TGConnectionTypeFriend forUser:nil withCompletionBlock:completionBlock];
}

+ (void)retrieveFollowsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    [[self sharedInstance].userManager retrieveConnectedUsersOfConnectionType:TGConnectionTypeFollow forUser:user withCompletionBlock:completionBlock];
}

+ (void)retrieveFollowersForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    [[self sharedInstance].userManager retrieveConnectedUsersOfConnectionType:TGConnectionTypeFollowers forUser:user withCompletionBlock:completionBlock];
}

+ (void)retrieveFriendsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    [[self sharedInstance].userManager retrieveConnectedUsersOfConnectionType:TGConnectionTypeFriend forUser:user withCompletionBlock:completionBlock];
}

+ (void)followUsersWithSocialsIds:(NSArray *)toSocialUsersIds
        onPlatfromWithSocialIdKey:(NSString *)socialIdKey
              withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager createSocialConnectionsForCurrentUserOnPlatformWithSocialIdKey:socialIdKey
                                                                  ofType:TGConnectionTypeFollow
                                                        toSocialUsersIds:toSocialUsersIds
                                                     withCompletionBlock:completionBlock];
}

+ (void)friendUsersWithSocialsIds:(NSArray *)toSocialUsersIds
                  onPlatfromWithSocialIdKey:(NSString *)socialIdKey
                        withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[self sharedInstance].userManager createSocialConnectionsForCurrentUserOnPlatformWithSocialIdKey:socialIdKey
                                                                  ofType:TGConnectionTypeFriend
                                                        toSocialUsersIds:toSocialUsersIds
                                                     withCompletionBlock:completionBlock];

}

#pragma mark - Events

+ (TGEvent*)createEventWithType:(NSString*)type onObject:(TGEventObject*)object {
    TGEvent *event = [[TGEvent alloc] init];
    event.type = type;
    event.object = object;
    [self createEvent:event];
    return event;
}

+ (TGEvent*)createEventWithType:(NSString*)type onObjectWithId:(NSString*)objectId {
    TGEventObject *object = [[TGEventObject alloc] init];
    object.objectId = objectId;
    return [self createEventWithType:type onObject:object];
}

+ (void)createEvent:(TGEvent*)event {
    [[self sharedInstance].eventManager addEvent:event];
}

+ (void)deleteEventEventWithType:(NSString*)type onObjectWithId:(NSString*)objectId {
    NSMutableArray *predicates = [NSMutableArray array];
    [predicates addObject:[NSPredicate predicateWithFormat:@"type=%@", type]];
    [predicates addObject:[NSPredicate predicateWithFormat:@"object.objectId=%@", type]];
    [predicates addObject:[NSPredicate predicateWithFormat:@"user.userId=%@", [TGUser currentUser].userId]];
    NSPredicate *searchEventPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];

    TGEvent *event = (TGEvent*)[[TGEvent cache] findFirstMatchingPredicate:searchEventPredicate];
    if (event) {
        [self deleteEvent:event];
    }
    else {
        TGLog(@"WARNING: no event found for type '%@' on object with id '%@'", type, objectId);
    }
}

+ (void)deleteEventEventWithType:(NSString*)type onObject:(TGEventObject*)object {
    [self deleteEventEventWithType:type onObjectWithId:object.objectId];
}

+ (void)deleteEvent:(TGEvent*)event {
    [[self sharedInstance].eventManager deleteEvent:event];
}

+ (void)createEventWithType:(NSString*)type withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    TGEvent *newEvent = [[TGEvent alloc] init];
    newEvent.type = type;
    [self createEvent:newEvent withCompletionBlock:completionBlock];
}

+ (void)createEventWithTypeAndObjectId:(NSString*)type
                           andObjectId:(NSString*)objectId
                   withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    TGEvent *newEvent = [[TGEvent alloc] init];
    newEvent.type = type;
    newEvent.object.objectId = objectId;
    [self createEvent:newEvent withCompletionBlock:completionBlock];
}

+ (void)createEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    [[self sharedInstance].eventManager createEvent:event withCompletionBlock:completionBlock];
}

+ (void)updateEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    [[self sharedInstance].eventManager updateEvent:event withCompletionBlock:completionBlock];
}

+ (void)deleteEventWithId:(NSString*)eventId withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    [[self sharedInstance].eventManager deleteEventWithId:eventId withCompletionBlock:completionBlock];
}

+ (void)retrieveEventForCurrentUserWithId:(NSString *)eventId withCompletionBlock:(TGGetEventCompletionBlock)completionBlock {
    [[self sharedInstance].eventManager retrieveEventForCurrentUserWithEventId:eventId withCompletionBlock:completionBlock];
}

+ (void)retrieveEventForUserWithId:(NSString *)userId
                        andEventId:(NSString *)eventId
               withCompletionBlock:(TGGetEventCompletionBlock)completionBlock {
    [[self sharedInstance].eventManager retrieveEventWithId:eventId forUserWithID:userId withCompletionBlock:completionBlock];
}

#pragma mark - Event lists

+ (void)retrieveEventsForCurrentUserWithCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    [self retrieveEventsForUser:nil withCompletionBlock:completionBlock];
}

+ (void)retrieveEventsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    [[self sharedInstance].eventManager retrieveEventsForUser:user withCompletionBlock:completionBlock];
}

+ (void)retrieveEventsForObjectId:(NSString*)objectId withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    [self retrieveEventsForObjectWithId:objectId andType:nil withCompletionBlock:completionBlock];
}

+ (void)retrieveEventsForObjectWithId:(NSString*)objectId andType:(NSString*)type withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    [[self sharedInstance].eventManager retrieveEventsForObjectWithId:objectId andType:type withCompletionBlock:completionBlock];
}

#pragma mark - Helper

- (NSUserDefaults*)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:TaplueSDKID];
    }
    return _userDefaults;
}

- (void)reset {
    [self.eventManager resetCaches];
}

- (void)dealloc {
    [self.userDefaults synchronize];
}

+ (NSString *)version {
    return @"1.0.3.3";
}


@end
