//
//  TGISOFormatterTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 04/06/15.
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

#import "TGTestCase.h"
#import "NSDateFormatter+TGISOFormatter.h"

@interface TGISOFormatterTests : TGTestCase
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation TGISOFormatterTests

- (void)setUp {
    [super setUp];
    self.dateFormatter = [NSDateFormatter tg_isoDateFormatter];
}

- (void)testDateFromString {
    expect([self.dateFormatter dateFromString:@"2015-06-01T08:44:57.144996856Z"]).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect([self.dateFormatter dateFromString:@"2015-06-01T08:44:57Z"]).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
}

- (void)testStringFromDate {
    expect([self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:1433148297]]).to.equal(@"2015-06-01T08:44:57Z");

}

@end
