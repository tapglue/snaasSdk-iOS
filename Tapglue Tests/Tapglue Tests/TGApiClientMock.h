//
//  TGApiClientMock.h
//  Tapglue Tests
//
//  Created by Martin Stemmle on 05/06/15.
//
//

#import "TGApiClient.h"

@interface TGApiClientMock : TGApiClient

@property (nonatomic, assign, getter=isOffline) BOOL offline;

@end
