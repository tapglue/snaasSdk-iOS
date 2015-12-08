//
//  TGPostsManager.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 08.12.15.
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

#import "TGBaseManager.h"
#import "TGConstants.h"

@class TGUser, TGPost;

@interface TGPostsManager : TGBaseManager

#pragma mark - Posts - 

#pragma mark CRUD

/*!
 @abstract Create a post.
 @discussion This will create an post for a the current user.
 
 @param post The TGPost object that contains the post information.
 */
- (void)createPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Update a post.
 @discussion This will update a post.
 
 @param event The TGPost object that contains the post information.
 */
- (void)updatePost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Delete a post.
 @discussion This will delete a post for a given id.
 
 @param postId the objectId of the post to be deleted.
 */
- (void)deletePostWithId:(NSString*)objectId withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve a post.
 @discussion This will retrieve a post for a given id.
 
 @param objectId The id of the post that should be fetched.
 */
- (void)retrievePostWithId:(NSString*)objectId withCompletionBlock:(TGGetPostCompletionBlock)completionBlock;

#pragma mark Lists


//Create Post	POST	/posts
//Retrieve Post	GET	/posts/{postID}
//Update Post	PUT	/posts/{postID}
//Delete Post	DELETE	/posts/{postID}
//Retrieve all Posts	GET	/posts
//Retrieve Posts Feed	GET	/me/feed/posts
//Retrieve my Posts	GET	/me/posts
//Retrieve users Posts	GET	/users/{userID}/posts


#pragma mark - Comments



#pragma mark - Likes


@end
