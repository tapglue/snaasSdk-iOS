//
//  TGApiClientTests.m
//  Tests
//
//  Created by Martin Stemmle on 09/12/15.
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
