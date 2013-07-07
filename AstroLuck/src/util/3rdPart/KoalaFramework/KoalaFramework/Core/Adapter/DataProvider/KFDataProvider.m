//
//  KFDataProvider.m
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/25/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFDataProvider.h"

@interface KFDataProvider () {
}

@end

@implementation KFDataProvider

@synthesize keyConfigureArray = _keyConfigureArray, valueConfigureArray = _valueConfigureArray;
@synthesize cacheRule = _cacheRule, parserClass = _parserClass,type=_type;

- (void)initCacheDBConfigure { // only called once for init
    _keyConfigureArray = [[NSMutableArray alloc] initWithCapacity:3];
    _valueConfigureArray = [[NSMutableArray alloc] initWithCapacity:3];
}

- (void)addRequestWithDelegate:(id<KFNetworkDelegate>)delegate {
    [[KFNetwork sharedInstance] addRequest:self delegate:delegate];
}

- (NSString*)tableName {
    return [NSString stringWithFormat:@"table_%@", ([_type length] > 0) ? _type : @"default"];
}

- (void)dealloc {
    KFLog(@"dealloc KFDataProvider");
    KF_RELEASE_SAFELY(_type);
    KF_RELEASE_SAFELY(_keyConfigureArray);
    KF_RELEASE_SAFELY(_valueConfigureArray);
    [self cancelRequest];
    [super dealloc];
}

- (void)cancelRequest {
    if (self.requestID > 0) {
        [[KFNetwork sharedInstance] cancelForReqParam:self];
        self.requestID = 0;
    }
}

- (int64_t)sendRequest {
    if (self.requestID > 0) {
        [[KFNetwork sharedInstance] startReqForParam:self];
    }
    return self.requestID;
}

- (BOOL)isFromNetwork {
    KFLog(@"isFromNetwork is called");
    switch (_cacheRule) {
		case KFCacheRuleLocal:
			return [self KFCacheRuleLocalMethod];
		case KFCacheRuleLocalAndNetwork:
			return [self KFCacheRuleLocalAndNetworkMethod];
        case KFCacheRuleNetwork:
		default:
			return [self KFCacheRuleNetworkMethod];
	}
}

- (BOOL)KFCacheRuleLocalMethod {
    KFLog(@"KFCacheRuleLocalMethod called");
    return YES;
}

- (BOOL)KFCacheRuleLocalAndNetworkMethod {
    KFLog(@"KFCacheRuleLocalAndNetworkMethod");
    return YES;
}

- (BOOL)KFCacheRuleNetworkMethod {
    KFLog(@"KFCacheRuleNetworkMethod");
    return YES;
}

@end
