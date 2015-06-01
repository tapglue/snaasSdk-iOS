//
//  TGConstants.h
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

#pragma mark - Errors

/*!
 @abstract Defines the Tapglue error domain.
 @constant TGErrorDomain holds the Tapglue error domain.
 */
static NSString *const TGErrorDomain = @"TapglueErrorDomain";

/*!
 @typedef Tapglue Errors
 @abstract `TGErrorCode` enum contains all custom error codes.
 @discussion `TGErrorCode` enum contains all custom error codes that are used as `code` for `NSError` for callbacks on all classes. These codes are used when `domain` of `NSError` that you receive is set to `TGErrorDomain`.
 */
typedef NS_ENUM(NSInteger, TGErrorCode) {
    
    /*!
     @abstract An unknown error happened.
     */
    kTGErrorUnknownError = 100,
    
    /*!
     @abstract An error if multiple errors occured during the request.
     */
    kTGErrorMultipleErrors = 101,
    
    /*!
     @abstract This error occuers when trying to save or delete resources without permission.
	 @discussion E.g. when attempting to save or delelete other users or other users' events. 
     */
    kTGErrorNoPermission = 102,

    /*!
     @abstract The current user has no social id set for the given plattform.
     */
    kTGErrorNoSocialIdForPlattform = 103,
    
    /*!
     @abstract Occures whenever any precodition are to fulfilled.
     */
    kTGErrorInconsistentData = 104,
    
    /*!
     @abstract An internal server error occured without further information.
     */
    kTGErrorInternalServerError = 1000,
    
    /*!
     @abstract Our service is currently unavailable.
     */
    kTGErrorServiceUnavailable = 1003,
    
    /*!
     @abstract The request timed out.
     */
    kTGErrorGatewayTimeout = 1004,
    
    /*!
     @abstract Something went during the authentication.
     */
    kTGErrorWrongAuthentication = 2100,
    
    /*!
     @abstract There was no token provided in the request.
     */
    kTGErrorNoToken = 2101,
    
    /*!
     @abstract The provided token is not correct.
     */
    kTGErrorWrongToken = 2102,
    
    /*!
     @abstract The provided token has been deactivated.
     */
    kTGErrorTokenDeactivated = 2103,
    
    /*!
     @abstract You are not authorized to make the request.
     */
    kTGErrorNotAuthorized = 2110,
    
    /*!
     @abstract The endpoint doesn't exist.
     */
    kTGErrorEndpointNotExist = 2200,
    
    /*!
     @abstract The API Version you are trying to use has been disabled.
     */
    kTGErrorAPIVersionDisabled = 2210,
    
    /*!
     @abstract The endpoint you are trying to adress retired.
     */
    kTGErrorEndpointRetired = 2220,
    
    /*!
     @abstract The rate limits have been exceeded.
     */
    kTGErrorRateLimitExceeded = 2300,
    
    /*!
     @abstract The payload of the request is to large.
     */
    kTGErrorRequestBodyToLarge = 2310,
    
    /*!
     @abstract A Wrong query was performed in the request.
     */
    kTGErrorWrongQuery = 2320,
    
    /*!
     @abstract The User-Agent was not set.
     */
    kTGErrorNoUserAgent = 2410,
    
    /*!
     @abstract A request with unsopported media type was made.
     */
    kTGErrorUnsupportedMediaType = 2420,
    
    /*!
     @abstract The payload could be processed properly.
     */
    kTGErrorUnprocessableEntity = 2430,
    
    /*!
     @abstract This HTTP Method is not allowed for the endpoint.
     */
    kTGErrorMethodNotAllows = 2440,
    
    /*!
     @abstract The username or Email was missing.
     */
    kTGErrorMissingUsernameOrEmail = 3100,
    
    /*!
     @abstract The password was missing.
     */
    kTGErrorMissingPassword = 3110,
    
    /*!
     @abstract The Username was invalid.
     */
    kTGErrorUsernameInvalid = 3120,
    
    /*!
     @abstract The Email was invalid.
     */
    kTGErrorEmailInvalid = 3130,
    
    /*!
     @abstract The Password was invalid.
     */
    kTGErrorPasswordInvalid = 3140,
    
    /*!
     @abstract The First name was invalid.
     */
    kTGErrorFirstNameInvalid = 3150,
    
    /*!
     @abstract The Last name was invalid.
     */
    kTGErrorLastNameInvalid = 3160,
    
    /*!
     @abstract The URL was invalid.
     */
    kTGErrorURLInvalid = 3170,
    
    /*!
     @abstract The Session was invalid.
     */
    kTGErrorInvalidSession = 3200,
    
    /*!
     @abstract The Session already expired.
     */
    kTGErrorExpiredSssion = 3210,
    
    /*!
     @abstract The User was not found.
     */
    kTGErrorUserNotFound = 3201,
    
    /*!
     @abstract The credentials are invalid.
     */
    kTGErrorInvalidCredentials = 3202,
    
    /*!
     @abstract The User already exists.
     */
    kTGErrorUserAlreadyExists = 3430,
    
    /*!
     @abstract The User id for creating the connection was invalid.
     */
    kTGErrorInvalidUserToId = 4110,
    
    /*!
     @abstract The connection type was invalid.
     */
    kTGErrorInvalidConnectionType = 4120,
    
    /*!
     @abstract The connection already exists.
     */
    kTGErrorConnectionAlreadyExists = 4130,
    
    /*!
     @abstract The event type was invalid.
     */
    kTGErrorInvalidEventType = 5110,
    
    /*!
     @abstract The event language was invalid.
     */
    kTGErrorInvalidEventLanguage = 5120,
    
    /*!
     @abstract The event priority was invalid.
     */
    kTGErrorInvalidEventPriority = 5130,
    
    /*!
     @abstract The event location was invalid.
     */
    kTGErrorInvalidLocation = 5140,
    
    /*!
     @abstract The event longitude was invalid.
     */
    kTGErrorInvalidLongitude = 5150,
    
    /*!
     @abstract The event latitude was invalid.
     */
    kTGErrorInvalidLatitude = 5160,
    
    /*!
     @abstract The event object was invalid.
     */
    kTGErrorInvalidObject = 5170,
    
    /*!
     @abstract The event was not found.
     */
    kTGErrorEventNotFound = 5210,
    
    /*!
     @abstract The metadata was invalid.
     */
    kTGErrorInvalidMetadata = 6110,
};

#pragma mark - Blocks 

@class TGUser, TGEvent;

/*!
 @abstract Completion block for succes.
 @discussion The TGSucessCompletionBlock will return a success and an error.
 */
typedef void (^TGSucessCompletionBlock)(BOOL success, NSError *error);

/*!
 @abstract Completion block for a user.
 @discussion The TGGetUserCompletionBlock will return a user and an error.
 */
typedef void (^TGGetUserCompletionBlock)(TGUser *user, NSError *error);

/*!
 @abstract Completion block for an event.
 @discussion The TGGetEventCompletionBlock will return an event and an error.
 */
typedef void (^TGGetEventCompletionBlock)(TGEvent *event, NSError *error);

/*!
 @abstract Completion block for a feed.
 @discussion The TGFeedCompletionBlock will return the events, the unreadCount and an error.
 */
typedef void (^TGFeedCompletionBlock)(NSArray *events, NSInteger unreadCount, NSError *error);