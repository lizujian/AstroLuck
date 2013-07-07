//
//  KFLogicService.m
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/23/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFLogicService.h"

@interface KFLogicService () {
}

@end


static KFLogicService *singleton;

@implementation KFLogicService

#pragma mark -
#pragma mark singleton methods

+ (KFLogicService*)GetInstance {
    if (nil == singleton) {
        @synchronized(self) {
            singleton = [[super allocWithZone:NULL] init];
        }
    }
    return singleton;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [[self GetInstance] retain];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    // do nothing here
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark object method

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark cancel methods

- (void)cancelWithSeqID:(int64_t)seqID {
    KFLog(@"cancelWithSeqID: %lli", seqID);
    [[KFNetwork sharedInstance] cancelForReqId:seqID];
}

#pragma mark -
#pragma mark send_request methods

- (int64_t)_sendReuqestWithDataProvider:(KFDataProvider*)provider {
    if ([provider isFromNetwork]) { // Decide whether to use network request
        return [provider sendRequest];
    }
    else {
        return 0; // return 0 if no need for requesting from network
    }
}

@end
