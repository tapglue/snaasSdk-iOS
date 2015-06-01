#import "EXPMatchers+beKindOfOrNil.h"

EXPMatcherImplementationBegin(beKindOfOrNil, (Class expected)) {
    BOOL actualIsNil = (actual == nil);
    BOOL expectedIsNil = (expected == nil);
    
    prerequisite(^BOOL{
        return !expectedIsNil;
    });
    
    match(^BOOL{
        return actualIsNil || [actual isKindOfClass:expected];
    });
    
    failureMessageForTo(^NSString *{
        if(expectedIsNil) return @"the expected value is nil/null";
        return [NSString stringWithFormat:@"expected: a kind of %@ or nil/null, got: an instance of %@, which is not a kind of %@", [expected class], [actual class], [expected class]];
    });
    
    failureMessageForNotTo(^NSString *{
        if(actualIsNil) return @"the actual value is nil/null";
        if(expectedIsNil) return @"the expected value is nil/null";
        return [NSString stringWithFormat:@"expected: nether a kind of %@ nor nil/null, got: an instance of %@, which is a kind of %@", [expected class], [actual class], [expected class]];
    });
}
EXPMatcherImplementationEnd

EXPMatcherAliasImplementation(beAKindOfOrNil, beKindOfOrNil, (Class expected));
