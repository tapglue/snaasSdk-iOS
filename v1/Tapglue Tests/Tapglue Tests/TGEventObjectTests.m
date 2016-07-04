//
//  TGEventObjectTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 03/06/15.
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
#import "TGEventObject.h"
#import "TGModelObject+Private.h"

@interface TGEventObjectTests : TGTestCase

@end

@implementation TGEventObjectTests

- (void)testInitWithDictionary {
    NSDictionary *objectData = @{
                                @"id" : @"a47f173d-d996-5ab7-ba02-621e00ff3297",
                                @"type" : @"something",
                                @"url" : @"http://www.inter.net",
                                @"display_names" : @{
                                        @"de" : @"Das Internet",
                                        @"en" : @"the internet"
                                        }
                                };

    TGEventObject *object = [[TGEventObject alloc] initWithDictionary:objectData];
    expect(object.objectId).to.equal(@"a47f173d-d996-5ab7-ba02-621e00ff3297");
    expect(object.type).to.equal(@"something");
    expect(object.url).to.equal(@"http://www.inter.net");
    expect([object displayNameForLanguage:@"de"]).to.equal(@"Das Internet");
    expect([object displayNameForLanguage:@"en"]).to.equal(@"the internet");
    expect([object displayNameForLanguage:@"fr"]).to.equal(@"the internet");
}

- (void)testInitWithDictionaryCalledWithNSNull {
    id nullDict = [NSNull null];
    expect([[TGEventObject alloc] initWithDictionary:nullDict]).to.beNil();
}

- (void)testToJsonDictionary {
    TGEventObject *object = [[TGEventObject alloc] init];
    object.objectId = @"a47f173d-d996-5ab7-ba02-621e00ff3297";
    object.type = @"something";
    object.url = @"http://www.inter.net";
    [object setDisplayName:@"Das Internet" forLanguage:@"de"];
    [object setDisplayName:@"the internet" forLanguage:@"en"];

    NSDictionary *jsonDictionary = object.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKeyPath:@"id"]).to.equal(@"a47f173d-d996-5ab7-ba02-621e00ff3297");
    expect([jsonDictionary valueForKeyPath:@"type"]).to.equal(@"something");
    expect([jsonDictionary valueForKeyPath:@"url"]).to.equal(@"http://www.inter.net");
    expect([jsonDictionary valueForKeyPath:@"display_names"]).to.equal(@{
                                                                                @"de" : @"Das Internet",
                                                                                @"en" : @"the internet"
                                                                                });
}


- (void)testSetDisplayNameForLanguageOnRetrievedObject {
    NSDictionary *objectData = @{
                                 @"id" : @"a47f173d-d996-5ab7-ba02-621e00ff3297",
                                 @"type" : @"something",
                                 @"url" : @"http://www.inter.net",
                                 @"display_names" : @{
                                         @"de" : @"Das Internet",
                                         @"en" : @"the internet"
                                         }
                                 };

    TGEventObject *object = [[TGEventObject alloc] initWithDictionary:objectData];

    expect([object displayNameForLanguage:@"fr"]).to.equal(@"the internet");
    [object setDisplayName:@"l'Internet" forLanguage:@"fr"];
    expect([object displayNameForLanguage:@"fr"]).to.equal(@"l'Internet");
}

- (void)testSetDisplayNameForLanguageOnNewObject {
    TGEventObject *object = [TGEventObject new];
    expect([object displayNameForLanguage:@"fr"]).to.beNil();
    [object setDisplayName:@"l'Internet" forLanguage:@"fr"];
    expect([object displayNameForLanguage:@"fr"]).to.equal(@"l'Internet");
}

@end
