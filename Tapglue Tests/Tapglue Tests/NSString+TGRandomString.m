//
//  NSString+TGRandomString.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 08/06/15.
//
//

#import "NSString+TGRandomString.h"

@implementation NSString (TGRandomString)

+ (NSString*)randomStringWithLength:(int)len {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    for (NSUInteger i = 0U; i < len; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [randomString appendFormat:@"%C", c];
    }
    return randomString;
}

@end
