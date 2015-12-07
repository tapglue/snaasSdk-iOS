//
//  TGConnection+Private.h
//  Tests
//
//  Created by Martin Stemmle on 07.12.15.
//
//

#import "TGConnection.h"

@interface TGConnection (Private)

- (instancetype)initWithDictionary:(NSDictionary*)data;
+ (NSString*)stringForConnectionState:(TGConnectionState)connectionState;

@end
