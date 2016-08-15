//
//  TGPostIntegrationTests.m
//  Tapglue Tests
//
//  Created by Onur Akpolat on 10/12/15.
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
#import "TGIntegrationTestCase.h"
#import "TGObject+Private.h"
#import "Tapglue+Private.h"
#import "NSString+TGRandomString.h"

@interface TGPostIntegrationTests : TGIntegrationTestCase

@end

@implementation TGPostIntegrationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test setUp will finish"];

    [Tapglue createAndLoginUserWithEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        
        [Tapglue createAndLoginUserWithUsername:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:3000.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [Tapglue loginWithUsernameOrEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).will.beTruthy();
        expect(error).will.beNil();
        
        TGUser *currentBUser = [TGUser currentUser];
        [currentBUser deleteWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).will.beTruthy();
            expect(error).will.beNil();
            expect([TGUser currentUser]).to.beNil();
            
            [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).will.beTruthy();
                expect(error).will.beNil();
                
                TGUser *currentBUser = [TGUser currentUser];
                [currentBUser deleteWithCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).will.beTruthy();
                    expect(error).will.beNil();
                    expect([TGUser currentUser]).to.beNil();
                }];
            }];
        }];
    }];
}

#pragma mark - CRUD POST -

#pragma mark - Correct

// [Correct] CRUD Post
- (void)testCRUDPost {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
                  
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"This is the Text of the Post."} andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Retrieve Post
            [Tapglue retrievePostWithId:post.objectId withCompletionBlock:^(TGPost *post, NSError *error) {
                expect(post).toNot.beNil();
                expect(error).to.beNil();
                
                // Add URL to Post
                [post addAttachment:[TGAttachment attachmentWithURL: @{@"en":@"http://bit.ly/123.gif"} andName:@"thumb"]];
                
                // Update Post
                [Tapglue updatePost:post withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    
                    // Delete Post
                    [Tapglue deletePostWithId:post.objectId withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [expectation fulfill];
                    }];
                    
                }];
            }];
        }];
    }];
}

// [Correct] Test Post Lists
- (void)testPostLists {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"This is the Text of the Post."} andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            expect(post.objectId).toNot.beNil();
            
            // Retrieve my posts
            [Tapglue retrievePostsForCurrentUserWithCompletionBlock:^(NSArray *posts, NSError *error) {
                expect(posts).toNot.beNil();
                expect(posts.count).to.beGreaterThanOrEqualTo(1);
                
                TGPost *newPost = posts.firstObject;
                expect(newPost.user).to.equal([TGUser currentUser]);
                expect(error).to.beNil();
                
                // Retrieve all posts
                [Tapglue retrieveAllPostsWithCompletionBlock:^(NSArray *posts, NSError *error) {
                    expect(posts).toNot.beNil();
                    expect(posts.count).to.beGreaterThanOrEqualTo(1);
                    expect(error).to.beNil();
                    
                    // Delete Post
                    [Tapglue deletePostWithId:post.objectId withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - CRUD Comments -

#pragma mark - Correct

// [Correct] Test Post Lists
- (void)testCRUDComments {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"This is the Text of the Post."} andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Create Comment
            [Tapglue createCommentWithContent:@{@"en":@"great post!"} forPost:post withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                
                // Retrieve Comments
                [Tapglue retrieveCommentsForPost:post withCompletionBlock:^(NSArray *comments, NSError *error) {
                    expect(comments).toNot.beNil();
                    expect(error).to.beNil();
                    
                    TGComment *comment = comments.firstObject;
                    comment.contents = @{@"en":@"bad post!"};
                    
                    // Update Comment
                    [Tapglue updateComment:comment withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        // Delete Comment
                        [Tapglue deleteComment:comment withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                            expect(error).to.beNil();
                            
                            [expectation fulfill];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

// [Correct] Test Post Lists
- (void)testCRUDCommentsViaPostObject {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"This is the Text of the Post."} andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Create Comment
            [post commentWithContent:@{@"en":@"great post!"} withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                
                // Retrieve Comments
                [Tapglue retrieveCommentsForPost:post withCompletionBlock:^(NSArray *comments, NSError *error) {
                    expect(comments).toNot.beNil();
                    expect(error).to.beNil();
                    
                    TGComment *comment = comments.firstObject;
                    comment.contents = @{@"en":@"bad post!"};
                    
                    // Update Comment
                    [Tapglue updateComment:comment withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        // Delete Comment
                        [Tapglue deleteComment:comment withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                            expect(error).to.beNil();
                            
                            [expectation fulfill];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

// [Correct] Test Post Lists
- (void)testCRUDLikes {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"This is the Text of the Post."} andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            expect(post.objectId).toNot.beNil();
            
            // Create Like
            [Tapglue createLikeForPost:post withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                // Retrieve Likes
                [Tapglue retrieveLikesForPost:post withCompletionBlock:^(NSArray *likes, NSError *error) {
                    expect(likes).toNot.beNil();
                    expect(error).to.beNil();

                    TGLike *like = likes.firstObject;
                    expect(like).toNot.beNil();
                
                    // Delete Like
                    [Tapglue deleteLike:post withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

// [Correct] Test Post Lists
- (void)testCRUDLikesViaPostObject {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"This is the Text of the Post."} andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Create Like
            [post likeWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                
                // Retrieve Likes
                [Tapglue retrieveLikesForPost:post withCompletionBlock:^(NSArray *likes, NSError *error) {
                    expect(likes).toNot.beNil();
                    expect(error).to.beNil();
                    
                    TGLike *like = likes.firstObject;
                    expect(like).toNot.beNil();
                    
                    // Delete Like
                    [Tapglue deleteLike:post withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

// [Correct] Test Post Like with Id
- (void)testLikePostWithId
 {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"This is the Text of the Post."} andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            expect(post.objectId).toNot.beNil();
            
            // Create Like
            [Tapglue createLikeForPostWithId:post.objectId withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                // Retrieve Likes
                [Tapglue retrieveLikesForPost:post withCompletionBlock:^(NSArray *likes, NSError *error) {
                    expect(likes).toNot.beNil();
                    expect(error).to.beNil();
                    
                    TGLike *like = likes.firstObject;
                    expect(like).toNot.beNil();
                    
                    // Delete Like
                    [Tapglue deleteLikeForPostWithId:post.objectId withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

@end
