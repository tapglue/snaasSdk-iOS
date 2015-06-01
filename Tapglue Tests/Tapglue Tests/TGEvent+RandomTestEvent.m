//
//  TGEvent+RandomTestEvent.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 08/06/15.
//
//

#import "TGEvent+RandomTestEvent.h"
#import "NSArray+RandomObject.h"
#import "TGEventObject.h"
#import "TGObject+Private.h"
#import "NSString+TGRandomString.h"

@implementation TGEvent (RandomTestEvent)

+ (TGEvent*)randomTestEvent {
    TGEvent *randomEvent = [[TGEvent alloc] init];
    randomEvent.type = [self randomType];
    randomEvent.object = [[TGEventObject alloc] initWithDictionary:@{@"id" : [NSString randomStringWithLength:10] }];
    return randomEvent;
}

+ (NSString*)randomType {
    return @[@"like", @"favourit", @"add", @"check-in"].randomObject;
}


@end
