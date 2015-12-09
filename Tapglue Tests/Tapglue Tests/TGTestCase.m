//
//  TGTestCase.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 02/06/15.
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

@interface TGTestCase ()
@property (nonatomic, strong, readwrite) NSString *appToken;
@end

@implementation TGTestCase

- (NSString*)appToken {
    if (!_appToken) {
        NSString* plistPath = [[NSBundle bundleForClass:self.class] pathForResource:@"Secrets" ofType:@"plist"];
        NSDictionary *secrets = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        _appToken = [secrets valueForKey:@"appToken"];
    }
    if ([_appToken isEqualToString:@"<PUT YOUR TOKEN HERE>"]) {
        for(int i = 0; i < 10; i++) {
            NSLog(@"ERROR: appToken not set in secrets.plist ❗️❗️❗️");
        }
    };
    return _appToken;
}

- (TGConfiguration*)config {
    TGConfiguration *config = [TGConfiguration defaultConfiguration];
    config.loggingEnabled = YES;
    config.flushInterval = 0; // disable automatic flushing for the tests
    return config;
}

@end
