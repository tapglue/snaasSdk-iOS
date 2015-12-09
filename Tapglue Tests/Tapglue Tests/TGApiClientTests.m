//
//  TGApiClientTests.m
//  Tests
//
//  Created by Martin Stemmle on 09.12.15.
//
//

#import "TGTestCase.h"
#import "TGApiClient.h"

@interface TGApiClientTests : TGTestCase
@property (nonatomic, strong) TGApiClient *client;
@end

@interface TGApiClient (Testing)
- (NSError*)errorFromJsonResponse:(NSDictionary*)jsonResponse withHTTPStatus:(NSInteger)httpStatusCode;
@end

@implementation TGApiClientTests

- (void)setUp {
    [super setUp];
    self.client = [[TGApiClient alloc] initWithAppToken:@"foo" andConfig:nil];
}

- (void)testErrorParsingDoesNotCrash {
    NSString *errorResponseJson = @"{\"errors\":{\"0|\":\"bad request: json: cannot unmarshal number into Go value of type string\"}}";
    NSData *data = [errorResponseJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSError *err = [self.client errorFromJsonResponse:(NSDictionary*)jsonResponse withHTTPStatus:400];
    expect(err).toNot.beNil();
}

@end
