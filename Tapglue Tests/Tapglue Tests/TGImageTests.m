//
//  TGImageTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 29/09/15.
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
#import "TGImage.h"
#import "TGModelObject+Private.h"

#import "TGEventObject.h"

@interface TGImageTests : TGTestCase

@end

@implementation TGImageTests


- (void)testInitWithFullDictionary {
    NSDictionary *objectData = @{@"url" : @"http://images.tapglue.com/1/demouser/profile.jpg",
                                 @"type" : @"thumbnail",
                                 @"height" : @200,
                                 @"width" : @300
                                 };
    
    TGImage *image = [[TGImage alloc] initWithDictionary:objectData];
    
    expect(image.url).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect(image.type).to.equal(@"thumbnail");
    expect(image.size.height).to.equal(200);
    expect(image.size.width).to.equal(300);
}


- (void)testInitWithMinimumDictionary {
    NSDictionary *objectData = @{@"url" : @"http://images.tapglue.com/1/demouser/profile.jpg"};
    
    TGImage *image = [[TGImage alloc] initWithDictionary:objectData];
    
    expect(image.url).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect(image.type).to.beNil();
    expect(image.size).to.equal(CGSizeZero);
}

- (void)testInitWithDictionaryCalledWithNSNull {
    id nullDict = [NSNull null];
    expect([[TGEventObject alloc] initWithDictionary:nullDict]).to.beNil();
}

- (void)testToJsonDictionaryFullData {
    TGImage *image = [[TGImage alloc] init];
    image.url = @"http://images.tapglue.com/1/demouser/profile.jpg";
    image.type = @"thumbnail";
    image.size = CGSizeMake(200, 300);
    
    NSDictionary *jsonDictionary = image.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKeyPath:@"url"]).to.beKindOf([NSString class]);
    expect([jsonDictionary valueForKeyPath:@"url"]).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect([jsonDictionary valueForKeyPath:@"type"]).to.equal(@"thumbnail");
    expect([jsonDictionary valueForKeyPath:@"height"]).to.equal(300);
    expect([jsonDictionary valueForKeyPath:@"width"]).to.equal(200);
}

- (void)testToJsonDictionaryNoSize {
    TGImage *image = [[TGImage alloc] init];
    image.url = @"http://images.tapglue.com/1/demouser/profile.jpg";

    NSDictionary *jsonDictionary = image.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKeyPath:@"url"]).to.beKindOf([NSString class]);
    expect([jsonDictionary valueForKeyPath:@"url"]).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect([jsonDictionary valueForKeyPath:@"height"]).to.beNil();
    expect([jsonDictionary valueForKeyPath:@"width"]).to.beNil();
}

- (void)testToJsonDictionaryNoType {
    TGImage *image = [[TGImage alloc] init];
    image.url = @"http://images.tapglue.com/1/demouser/profile.jpg";
    
    NSDictionary *jsonDictionary = image.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKeyPath:@"url"]).to.beKindOf([NSString class]);
    expect([jsonDictionary valueForKeyPath:@"url"]).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect([jsonDictionary valueForKeyPath:@"type"]).to.beNil();
}



@end
