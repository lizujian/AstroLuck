//
//  KFDownLoadRequestParameter.m
//  KoalaFramework
//
//  Created by JHorn.Han on 10/29/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFDownLoadRequestParameter.h"
#import "ASIDownloadCache.h"
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
//[request setShouldContinueWhenAppEntersBackground:YES];

static NSString *_KFDownloadTemDirectory;


static inline BOOL createDirectory(NSString* path) {
    if (nil == path || 0 == [path length]) {
        return NO;
    }
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        //KFLog(@"Already exist: %@", path);
        return YES;
    }
    else {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            //  KFLog(@"Fail to create %@, because of: %@", path, [error description]);
            return NO;
        }
        else {
            //  KFLog(@"Succeed to create %@", path);
            return YES;
        }
    }
}


static inline NSString *KFDownTempCacheDirectory() {
	if(!_KFDownloadTemDirectory) {
		_KFDownloadTemDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/.bd_kfDownloadTemp_"] copy];
        createDirectory(_KFDownloadTemDirectory);
	}
    
	return _KFDownloadTemDirectory;
}


@interface KFDownLoadRequestParameter()
{
    
}

@end

@implementation KFDownLoadRequestParameter
@synthesize downloadDestinationPath = _downloadDestinationPath;
@synthesize tempDownloadDir = _tempDownloadDir;
@synthesize downloadStatus = _downloadStatus;
@synthesize totalSize = _totalSize;
@synthesize curSize = _curSize;
//@synthesize tempDownloadDir = _tempDownloadDir;

//
//-(NSString*)downloadTempPath {
//    
//    return self.tempDownloadDir;
//}


-(id)init {
    if(self = [super init]) {
       // self.tempDownloadDir = KFDownTempCacheDirectory();
        self.downloadStatus = DownloadNotStart;
    }
    return self;
}

-(void)dealloc {
    
    self.downloadDestinationPath = nil;
    self.tempDownloadDir = nil;
    [super dealloc];
}

+ (BOOL)createDirectory:(NSString*)path {
    if (nil == path || 0 == [path length]) {
        return NO;
    }
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        //KFLog(@"Already exist: %@", path);
        return YES;
    }
    else {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            //  KFLog(@"Fail to create %@, because of: %@", path, [error description]);
            return NO;
        }
        else {
            //  KFLog(@"Succeed to create %@", path);
            return YES;
        }
    }
}
@end
