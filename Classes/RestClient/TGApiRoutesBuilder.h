//
//  TGApiRoutesBuilder.h
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


#import <Foundation/Foundation.h>

@interface TGApiRoutesBuilder : NSObject

#pragma mark - Events

/*!
 @param userId The userId for aonther user or `nil` for the current user.
 @return The route to get the events of a particlar user.
 */
+ (NSString*)routeForEventsOfUserWithId:(NSString*)userId;


#pragma mark - Posts

/*!
 @param userId The userId for aonther user or `nil` for the current user.
 @return The route to get the posts of a particlar user.
 */
+ (NSString*)routeForPostsOfUserWithId:(NSString*)userId;


#pragma mark - Feeds

/*!
 @return The route to get the feed of posts for the current user.
 */
+ (NSString*)routeForPostsFeed;

/*!
 @return The route to get the feed of events for the current user.
 */
+ (NSString*)routeForEventsFeed;

/*!
 @return The route to get the mixed feed of posts & events for the current user.
 */
+ (NSString*)routeForMixedFeed;


@end
