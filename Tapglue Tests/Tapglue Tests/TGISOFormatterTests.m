//
//  TGISOFormatterTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 04/06/15.
//
//

#import "TGTestCase.h"
#import "NSDateFormatter+TGISOFormatter.h"

@interface TGISOFormatterTests : TGTestCase
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation TGISOFormatterTests

- (void)setUp {
    [super setUp];
    self.dateFormatter = [NSDateFormatter tg_isoDateFormatter];
}

- (void)testDateFromString {
    expect([self.dateFormatter dateFromString:@"2015-06-01T08:44:57.144996856Z"]).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect([self.dateFormatter dateFromString:@"2015-06-01T08:44:57Z"]).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
}

- (void)testStringFromDate {
    expect([self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:1433148297]]).to.equal(@"2015-06-01T08:44:57Z");
    
}

@end
