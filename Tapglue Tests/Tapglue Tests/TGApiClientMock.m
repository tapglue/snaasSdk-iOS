//
//  TGApiClientMock.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 05/06/15.
//
//

#import "TGApiClientMock.h"
#import "TGConstants.h"
#import "NSError+TGError.h"

@interface TGApiClient (Private)

- (NSURLSessionDataTask*)makeRequestWithHTTPMethod:(NSString*)method
                                        atEndPoint:(NSString*)endPoint
                                 withURLParameters:(NSDictionary*)urlParams
                                        andPayload:(NSDictionary*)bodyObject
                                andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock;
    

@end

@implementation TGApiClientMock

- (NSURLSessionDataTask*)makeRequestWithHTTPMethod:(NSString *)method atEndPoint:(NSString *)endPoint withURLParameters:(NSDictionary *)urlParams andPayload:(NSDictionary *)bodyObject andCompletionBlock:(void (^)(NSDictionary *, NSError *))completionBlock {
    
    if (!self.isOffline) {
        
        completionBlock(nil, nil);
        // TODO: mock response if not offline
        
        
//        return [super makeRequestWithHTTPMethod:method
//                              atEndPoint:endPoint
//                       withURLParameters:urlParams
//                              andPayload:bodyObject
//                      andCompletionBlock:completionBlock];
    }
    else {
        NSError *error = [NSError tg_errorWithCode:1000 userInfo:nil];
        completionBlock(nil, error);
    }
    return nil;
}

@end
