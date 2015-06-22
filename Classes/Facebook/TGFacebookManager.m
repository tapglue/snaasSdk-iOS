//
//  TGFacebookManager.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 11/06/15.
//
//

#import "TGFacebookManager.h"
#import "Tapglue+Private.h"

#import "TGUser+Private.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface TGFacebookManager () 

@end

@implementation TGFacebookManager

#pragma mark - FBSDKLoginButtonDelegate

- (NSArray*)readPermissions {
    return @[@"public_profile", @"email", @"user_friends"];
}


- (void)loginWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[[FBSDKLoginManager alloc] init] logInWithReadPermissions:self.readPermissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [self handleFacebookLoginWithResult:result error:error andCompletionBlock:completionBlock];
    }];
}

- (void)logout {
    [[[FBSDKLoginManager alloc] init] logOut];
    [self loginButtonDidLogOut:nil];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error  {
    [self handleFacebookLoginWithResult:result error:error andCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            if ([self.delegate respondsToSelector:@selector(socialManager:loginFinishedViaButton:)]) {
                [self.delegate socialManager:self loginFinishedViaButton:loginButton];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(socialManager:loginViaButton:failedWithError:)]) {
                [self.delegate socialManager:self loginViaButton:loginButton failedWithError:error];
            }
        }
    }];
}

- (void)handleFacebookLoginWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)fbLoginError andCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    
    // TODO: consider moving all this to the background
    
    BOOL success = NO;
    NSError *error;
    BOOL callCompletion = YES;
    
    if (fbLoginError) {
        // TODO: Process error
        error = fbLoginError;
    } else if (result.isCancelled) {
        // TODO: Handle cancellations
        
        
    } else {
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if ([result.grantedPermissions containsObject:@"email"]) {
            // Do work
            callCompletion = NO;
            [self createUserFromFacebookMeWithCompletionBlock:^(TGUser *user, NSError *error) {
                if (user && !error) {
                    [self updateFriendsForCurrentUserWithCompletionBlock:nil];
                    if (completionBlock) {
                        completionBlock(YES, nil);
                    }
                }
                else {
                    // TODO: Handle error
                    if (completionBlock) {
                        completionBlock(NO, error);
                    }
                }
            }];
        }
        // TODO: handle error
//        error = 
    }
    
    
    if (completionBlock && callCompletion) {
        completionBlock(success, error);
    }
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            TGLog(@"User logged out")
        } else {
            TGLog(@"Logout failed with error: %@", error);
        }
    }];
}


#pragma mark - 

- (void)createUserFromFacebookMeWithCompletionBlock:(void (^)(TGUser *user, NSError *error))completionBlock {

    FBSDKGraphRequest *meRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [meRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (result && !error) {
            TGUser *user = [[TGUser alloc] init];
            user.email = [result valueForKey:@"email"];
            user.email = [user.email stringByAppendingString:@"e"];
            user.firstName = [result valueForKey:@"first_name"];
            user.lastName = [result valueForKey:@"last_name"];
            NSString *facebookId = [result valueForKey:@"id"];
            [user setSocialId:facebookId forKey:TGUserSocialIdFacebookKey];
            
            if ([self.delegate respondsToSelector:@selector(socialManager:passwordForNewUser:)]) {
                [user setPassword:[self.delegate socialManager:self passwordForNewUser:user]];
            }
            else {
                TGLog(@"WARNING: no custom password implementation for facebook users"); // ??? maybe a nicer log
                [user setPassword:facebookId];
            }
            
            [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
                if (success) {
                    TGLog(@"Created / logged in user")
                    if (completionBlock) {
                        completionBlock(user, nil);
                    }
                }
                else {
                    TGLog(@"Failed to create or login tapglue user with error: %@", error);
                    if (completionBlock) {
                        completionBlock(nil, error);
                    }
                }
            }];
        }
        else {
            TGLog(@"Failed to fetch user data with error: %@", error);
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)updateFriendsForCurrentUserWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    
//    NSDictionary *params = @{ @"fields": (([FBSettings isPlatformCompatibilityEnabled]) ?
//                                          @"id,name,username,first_name,last_name" :
//                                          @"id,name,first_name,last_name") };

    FBSDKGraphRequest *myFriendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil];

    [myFriendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (result && !error) {
            NSArray *friendsIds = [result valueForKeyPath:@"data.id"];
            TGLog(@"Fetch Facebook friends: found %ld IDs of facebook friends", friendsIds.count);
            
            [Tapglue friendUsersWithSocialsIds:friendsIds
                     onPlatfromWithSocialIdKey:TGUserSocialIdFacebookKey
                           withCompletionBlock:^(BOOL success, NSError *error) {
                               if (success) {
                                   TGLog(@"Added friends")
                               }
                               else {
                                   TGLog(@"Failed to add friends with error: %@", error);
                               }
                               if (completionBlock) {
                                   completionBlock(success, error);
                               }
                           }];
            
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
        
    }];

    
}

@end
