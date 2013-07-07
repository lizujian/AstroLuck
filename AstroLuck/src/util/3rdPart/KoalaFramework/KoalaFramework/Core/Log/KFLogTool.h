//
//  KFLog.h
//  KoalaFramework
//
//  Created by lixianhui on 12-11-12.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "DDLog.h"

// 写日志的接口，大家使用该接口，替换之前的NSLog，并使用不同的级别
#define KFLogError(frmt, ...)   DDLogError(frmt, ##__VA_ARGS__)
#define KFLogWarn(frmt, ...)    DDLogWarn(frmt, ##__VA_ARGS__)
#define KFLogInfo(frmt, ...)    DDLogInfo(frmt, ##__VA_ARGS__)
#define KFLogDebug(frmt, ...) DDLogVerbose(frmt, ##__VA_ARGS__)

// 函数进入点
#define KFLogFunctionStart  DDLogVerbose(@"func start");
#define KFLogFunctionStartInfo(info)  DDLogVerbose(@"func start: %@", info);

// 函数离开点
#define KFLogFunctionEnd DDLogVerbose(@"func end");
#define KFLogFunctionEndInfo(info) DDLogVerbose(@"func end: %@", info);

// 日志的级别
typedef enum {
    KFLogLevelOff = LOG_LEVEL_OFF,
    KFLogLevelError = LOG_LEVEL_ERROR,
    KFLogLevelWarn = LOG_LEVEL_WARN,
    KFLogLevelInfo = LOG_LEVEL_INFO,
    KFLogLevelDebug = LOG_LEVEL_VERBOSE
} KFLogLevel;

extern KFLogLevel ddLogLevel;

// 在didFinishLaunchingWithOptions调用 [KFLogTool sharedInstance];
// 之后就可以使用KFLogError等函数了
@interface KFLogTool : NSObject<DDLogFormatter>

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KFLogTool);

// 设置日志级别
- (void)setLogLevel:(KFLogLevel)aLevel;

// 一般情况，外部调用本函数即可
// 调用本函数，增加日志文件，默认的目录在NSCachesDirectory目录，1MB,60分钟循环，最多3个文件。
- (void)addDefaultFileLog;

// 调用本函数，增加日志文件的内容，
// 调用本函数，增加日志文件，
// aLogDirectory 目录
// maximumFileSize:
//   The approximate maximum size to allow log files to grow.
//   If a log file is larger than this value after a write,
//   then the log file is rolled.
//
// rollingFrequency
//   How often to roll the log file.
//   The frequency is given as an NSTimeInterval, which is a double that specifies the interval in seconds.
//   Once the log file gets to be this old, it is rolled.
// maximumNumberOfLogFiles
//   最多文件数目
- (void)addFileLogDirectory:(NSString *)aLogDirectory
            maximumFileSize:(NSUInteger)maximumFileSize
           rollingFrequency:(NSUInteger)rollingFrequency
    maximumNumberOfLogFiles:(NSUInteger)maximumNumberOfLogFiles;

// 停止日志文件记录
- (void)removeFileLog;

// 函数已被移除，之前加入该函数，未考虑苹果有NSStringFromCGRect函数
//- (void)logFrame:(CGRect)frame;

@end
