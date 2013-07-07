//
//  KFLogFileManagerDefault.m
//  KoalaFramework
//
//  Created by lixianhui on 12-12-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "KFLogFileManagerDefault.h"

@interface KFLogFileManagerDefault()

- (NSString *)defaultLogsDirectory;

@end

@implementation KFLogFileManagerDefault

- (id)init
{
	return [self initWithLogsDirectory:nil];
}

- (id)initWithLogsDirectory:(NSString *)aLogsDirectory
{
    NSString * logDirectory = nil;
    if ([aLogsDirectory isKindOfClass:[NSString class]]
        && [aLogsDirectory length] > 0) {
        logDirectory = aLogsDirectory;
    }else{
        logDirectory = [self defaultLogsDirectory];
    }
    
	if ((self = [super initWithLogsDirectory:aLogsDirectory]))
	{
	}
	return self;
}

- (NSString *)defaultLogsDirectory
{
#if TARGET_OS_IPHONE
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
#else
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	
	NSString *appName = [[NSProcessInfo processInfo] processName];
	
	NSString *baseDir = [basePath stringByAppendingPathComponent:appName];
#endif
	
	return [baseDir stringByAppendingPathComponent:@"Logs"];
}

@end
