//
//  TGEvent+RandomTestEvent.h
//  Tapglue Tests
//
//  Created by Martin Stemmle on 08/06/15.
//
//

#import "TGEvent.h"

@interface TGEvent (RandomTestEvent)

+ (TGEvent*)randomTestEvent;
+ (NSString*)randomType;

@end
