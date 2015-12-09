//
//  TGApiRoutesHelper.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 09.12.15.
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

#import "TGApiRoutesBuilder.h"

static NSString * const TGApiRouteUsers = @"users";
static NSString * const TGApiRouteCurrentUser = @"me";
static NSString * const TGApiRouteFeed = @"feed";
static NSString * const TGApiRoutePosts = @"posts";
static NSString * const TGApiRouteEvents = @"events";

@implementation TGApiRoutesBuilder

#pragma mark - Events

+ (NSString*)routeForEventsOfUserWithId:(NSString*)userId {
    return [[self baseRouteForUserWithId:userId] stringByAppendingPathComponent:TGApiRouteEvents];
}

#pragma mark - Posts

+ (NSString*)routeForAllPosts {
    return TGApiRoutePosts;
}

+ (NSString*)routeForPostWithId:(NSString*)postId {
    NSParameterAssert(postId);
    return [TGApiRoutePosts stringByAppendingPathComponent:postId];
}

+ (NSString*)routeForPostsOfUserWithId:(NSString*)userId {
    return [[self baseRouteForUserWithId:userId] stringByAppendingPathComponent:TGApiRoutePosts];
}

#pragma mark - Feeds

+ (NSString*)routeForPostsFeed {
    return [[self baseRouteForFeeds] stringByAppendingPathComponent:TGApiRoutePosts];
}

+ (NSString*)routeForEventsFeed {
    return [[self baseRouteForFeeds] stringByAppendingPathComponent:TGApiRouteEvents];
}

+ (NSString*)routeForMixedFeed {
    return [self baseRouteForFeeds];
}

+ (NSString*)baseRouteForFeeds {
    return [TGApiRouteCurrentUser stringByAppendingPathComponent:TGApiRouteFeed];
}


#pragma mark - Helper 

/*!
 @param userId The userId for aonther user or `nil` for the current user.
 */
+ (NSString*)baseRouteForUserWithId:(NSString*)userId {
    if (userId) {
        return [TGApiRouteUsers stringByAppendingPathComponent:userId];
    }
    else {
        return TGApiRouteCurrentUser;
    }
}


@end
