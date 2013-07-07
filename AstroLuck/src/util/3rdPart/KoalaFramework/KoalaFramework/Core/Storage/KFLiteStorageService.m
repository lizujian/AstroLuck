//
//  KFLiteStorageService.m
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/23/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFLiteStorageService.h"

#define DefaultUserID @"defaultUserLiteStorage"
#define GlobalLiteStorageKey @"gLiteStorage"

@interface KFLiteStorageService()  {
    NSMutableDictionary *_globalLiteStorage;
    NSMutableDictionary *_userLiteStorage;
    NSString *_userID;
}

@end


static KFLiteStorageService *singleton;

@implementation KFLiteStorageService

#pragma mark -
#pragma mark singleton methods

+ (KFLiteStorageService*)GetInstance {
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
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		
        _globalLiteStorage = [[NSMutableDictionary alloc] init];
		NSDictionary* gLiteStorage = [defaults dictionaryForKey:GlobalLiteStorageKey];
		if (gLiteStorage != nil) {
			[_globalLiteStorage addEntriesFromDictionary:gLiteStorage];
		}
        
        _userID = DefaultUserID;
        _userLiteStorage = [[NSMutableDictionary alloc] init];
        NSDictionary* uLiteStorage = [defaults dictionaryForKey:_userID];
        if (uLiteStorage != nil) {
            [_userLiteStorage addEntriesFromDictionary:uLiteStorage];
        }
    }
    return self;
}

- (void)dealloc {
	KF_RELEASE_SAFELY(_globalLiteStorage);
    KF_RELEASE_SAFELY(_userLiteStorage);
    KF_RELEASE_SAFELY(_userID);
	[super dealloc];
}

- (void)clearWithUserID:(NSString*)userID {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:(userID != nil && [userID length] > 0) ? userID : DefaultUserID];
    [defaults synchronize];
}

- (void)clearDefaultUserLiteStorage {
    [self clearWithUserID:nil];
}

- (void)cleaGlobalLiteStorage {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:GlobalLiteStorageKey];
    [defaults synchronize];
}

#pragma mark -
#pragma mark public method

- (void)switchToUserID:(NSString*)userID {
    NSString* newUserID = (userID != nil && [userID length] > 0) ? [[userID copy] autorelease] : DefaultUserID;
    if ([_userID compare:newUserID] == 0) {
        return;
    }
    
    @synchronized(self) {
        [_userLiteStorage removeAllObjects];
        KF_RELEASE_SAFELY(_userID);
        _userID = newUserID;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* userDict = [defaults dictionaryForKey:_userID];
        if (userDict != nil) {
            [_userLiteStorage addEntriesFromDictionary:userDict];
        }
    }
}

- (void)switchToDefaultUserID {
    [self switchToUserID:DefaultUserID];
}

- (NSMutableDictionary*)getUserLiteStorage {
	return _userLiteStorage;
}

- (void)saveUserLiteStorage {
    @synchronized(self) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_userLiteStorage forKey:_userID];
        [defaults synchronize];
    }
}

- (NSMutableDictionary*)getGlobalLiteStorage {
	return _globalLiteStorage;
}

- (void)saveGlobalLiteStorage {
    @synchronized(self) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_globalLiteStorage forKey:GlobalLiteStorageKey];
        [defaults synchronize];
    }
}

@end
