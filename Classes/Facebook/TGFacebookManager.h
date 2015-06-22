//
//  TGFacebookManager.h
//  Tapglue Tests
//
//  Created by Martin Stemmle on 11/06/15.
//
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TGConstants.h"

@class TGUser;

@protocol TGSocialManagerDelegate <NSObject>

@optional

// TODO : DOKU
- (void)socialManager:(id)manager loginFinishedViaButton:(UIButton*)sender;
- (void)socialManager:(id)manager loginViaButton:(UIButton*)sender failedWithError:(NSError*)error;

// TODO: DOKU
// - implement your own logig
// - consider asycing the user
- (NSString*)socialManager:(id)manager passwordForNewUser:(TGUser*)user; // TODO: check if this can called be async

@end

@interface TGFacebookManager : NSObject <FBSDKLoginButtonDelegate>

@property (nonatomic, strong, readonly) NSArray *readPermissions;
@property (nonatomic, strong) id<TGSocialManagerDelegate> delegate;

- (void)loginWithCompletionBlock:(TGSucessCompletionBlock)completionBlock;
- (void)logout;

#pragma mark - FBSDKLoginButtonDelegate
// for over loading
// TODO: doku
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error;
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton;

@end

