//
//  TGPostsManager.m
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

#import "TGPostsManager.h"
#import "TGApiClient.h"
#import "TGPost.h"
#import "TGModelObject+Private.h"
#import "Tapglue+Private.h"
#import "NSError+TGError.h"
#import "TGObjectCache.h"


static NSString *const TGPostsManagerAPIEndpointPosts = @"posts";

@implementation TGPostsManager

#pragma mark - Post -

#pragma mark CRUD

- (void)createPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client POST:TGPostsManagerAPIEndpointPosts withURLParameters:nil andPayload:post.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {

        [post loadDataFromDictionary:jsonResponse];
        
        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];

}

- (void)updatePost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client PUT:[self routeForPostWithId:post.objectId] withURLParameters:nil andPayload:post.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            completionBlock(error == nil, error);
        }
    }];
}

- (void)deletePostWithId:(NSString*)objectId withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client DELETE:[self routeForPostWithId:objectId] withCompletionBlock:completionBlock];
}

- (void)retrievePostWithId:(NSString*)objectId withCompletionBlock:(TGGetPostCompletionBlock)completionBlock {
    [self.client GET:[self routeForPostWithId:objectId] withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (jsonResponse && !error) {
            TGPost *post = [[TGPost alloc] initWithDictionary:jsonResponse];
            if (completionBlock) {
                completionBlock(post, nil);
            }
        }
        else if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}


#pragma mark Lists

- (void)retrieveAllPostsWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /posts
    [self retrievePostsAtRoute:TGPostsManagerAPIEndpointPosts withCompletionBlock:completionBlock];
}

- (void)retrievePostsFeedForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /me/feed/posts
    NSString *route = [TGApiEndpointCurrentUser stringByAppendingPathComponent:@"feed"];
    route = [route stringByAppendingPathComponent:TGPostsManagerAPIEndpointPosts];
    [self retrievePostsAtRoute:route withCompletionBlock:completionBlock];
}

- (void)retrievePostsForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /me/posts
    NSString *route = [TGApiEndpointCurrentUser stringByAppendingPathComponent:TGPostsManagerAPIEndpointPosts];
    [self retrievePostsAtRoute:route withCompletionBlock:completionBlock];
}

- (void)retrievePostsForUserWithId:(NSString*)userId withCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /users/{userID}/posts
    NSString *route = [TGApiEndpointUsers stringByAppendingPathComponent:userId];
    route = [route stringByAppendingPathComponent:TGPostsManagerAPIEndpointPosts];
    [self retrievePostsAtRoute:route withCompletionBlock:completionBlock];
}

- (void)retrievePostsAtRoute:(NSString*)route withCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    [self.client GET:route withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (!error) {
            NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
            [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
            
            NSArray *posts = [self postsFromJsonResponse:jsonResponse];
            
            if (completionBlock) {
                completionBlock(posts, nil);
            }
        }
        else if(completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

#pragma mark - Helper

- (NSString*)routeForPostWithId:(NSString*)postId {
    return [TGPostsManagerAPIEndpointPosts stringByAppendingPathComponent:postId];
}

- (NSArray*)postsFromJsonResponse:(NSDictionary*)jsonResponse {
    NSArray *postDictionaries = [jsonResponse objectForKey:@"posts"];
    NSMutableArray *posts = [NSMutableArray arrayWithCapacity:postDictionaries.count];
    for (NSDictionary *postData in postDictionaries) {
        TGPost *newPost = [[TGPost alloc] initWithDictionary:postData];
        [posts addObject:newPost];
    }
    return posts;
}















@end
