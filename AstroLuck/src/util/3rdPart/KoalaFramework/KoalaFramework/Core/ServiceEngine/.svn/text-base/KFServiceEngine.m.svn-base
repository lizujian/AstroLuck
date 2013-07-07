//
//  KFServiceEngine.m
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/23/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFServiceEngine.h"

static KFServiceEngine *singleton;

@implementation KFServiceEngine

#pragma mark -
#pragma mark Singleton reload methods

+ (KFServiceEngine*)GetInstance {
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
#pragma mark class methods

+ (KFDatabaseService*)DatabaseService {
    return [KFDatabaseService GetInstance];
}


+ (KFLiteStorageService*)LiteStorageService {
    return [KFLiteStorageService GetInstance];
}


+ (KFLogicService*)LogicService {
    return [KFLogicService GetInstance];
}

@end