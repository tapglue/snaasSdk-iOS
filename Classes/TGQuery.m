//
//  TGQueryBuilder.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 07.12.15.
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


#import "TGQuery.h"

@interface TGQuery ()
@property (nonatomic, strong) NSMutableDictionary *mutableQuery;
@end

@implementation TGQuery

- (instancetype) init {
    self = [super init];
    if (self) {
        self.mutableQuery = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary*)query {
    return self.mutableQuery.copy;
}

- (NSString*)queryAsString {
    return [self.class stringFromQuery:self.mutableQuery];
}

+ (NSString*)stringFromQuery:(NSDictionary*)query {
    NSData *data = [NSJSONSerialization dataWithJSONObject:query options:kNilOptions error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (void)addTypeEquals:(NSString*)type {
    if (type) {
        [self.mutableQuery setValue:@{@"eq":type} forKeyPath:@"type"];
    }
}

- (void)addObjectWithId:(NSString*)objectId {
    if (objectId) {
        [self.mutableQuery setValue:@{@"id":@{@"eq":objectId}} forKeyPath:@"object"];
    }
}



@end
