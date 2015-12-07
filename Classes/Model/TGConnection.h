//
//  TGConnection.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 07.12.2015.
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
#import "TGModelObject.h"
#import "TGUser.h"

//TODO: documentation
/*!
 @typedef Determines the connection state.
 @constant TGConnectionStatePending …
 @constant TGConnectionStateConfirmed …
 @constant TGConnectionStateRejected …
 */
typedef NS_ENUM(NSUInteger, TGConnectionState) {
    TGConnectionStatePending = 0,
    TGConnectionStateConfirmed,
    TGConnectionStateRejected
};

@interface TGConnection : NSObject

@property (nonatomic, strong, readonly) TGUser *fromUser;
@property (nonatomic, strong, readonly) TGUser *toUser;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, readonly) TGConnectionState state;

@end
