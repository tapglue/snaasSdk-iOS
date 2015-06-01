//
//  NSArray+RandomObject.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 08/06/15.
//
//

#import "NSArray+RandomObject.h"

@implementation NSArray (RandomObject)

- (NSUInteger)randomIndex {
    return arc4random() % self.count;
}

- (id)randomObject {
    return [self objectAtIndex:self.randomIndex];
}

@end
