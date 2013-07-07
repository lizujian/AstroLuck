//
//  KFRuntimeCrashReporter.h
//  KoalaFramework
//
//  Created by JHorn.Han on 12/14/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
@interface KFRuntimeCrashReporter : NSObject
{
	BOOL		_installed;
	NSString *	_logPath;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER( KFRuntimeCrashReporter );

@property (nonatomic, assign) BOOL			installed;
@property (nonatomic, retain) NSString *	logPath;

- (void)install;

@end