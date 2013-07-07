//
//  KFLog.m
//  KoalaFramework
//
//  Created by lixianhui on 12-11-12.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "KFLogTool.h"
#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "KFLogFileManagerDefault.h"

KFLogLevel ddLogLevel;

@interface KFLogTool()
{
    KFLogFileManagerDefault * logFileManagerDefault;
    DDFileLogger * fileLogger;
}

@end

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KFLogTool);
@implementation KFLogTool
SYNTHESIZE_SINGLETON_FOR_CLASS(KFLogTool);

- (id)init;
{
    self = [super init];
    if (self) {
        [[DDTTYLogger sharedInstance] setLogFormatter:self];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        [self setLogLevel:KFLogLevelInfo];
    }
    
    return self;
}

- (void)dealloc
{
    [logFileManagerDefault release];
    logFileManagerDefault = nil;
    
    [fileLogger release];
    fileLogger = nil;
    
    [super dealloc];
}

// 设置日志级别
- (void)setLogLevel:(KFLogLevel)aLevel
{
    ddLogLevel = aLevel;
}

#pragma mark DDLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString * levelText = @"";
    switch (logMessage->logLevel) {
        case LOG_LEVEL_OFF:
            levelText = @"O";
            break;
            
        case LOG_LEVEL_ERROR:
            levelText = @"E";
            break;
            
        case LOG_LEVEL_WARN:
            levelText = @"W";
            break;
            
        case LOG_LEVEL_INFO:
            levelText = @"I";
            break;
            
        case LOG_LEVEL_VERBOSE:
            levelText = @"D";
            break;
            
        default:
            levelText = @"D";
            break;
    }
    
#pragma mark 还需要增加日期、时间
    
	return [NSString stringWithFormat:@"%@ | %@ | %@ | %s @ %i | %@",
			levelText, logMessage->timestamp, [logMessage fileName], logMessage->function, logMessage->lineNumber, logMessage->logMsg];
}

//- (void)logFrame:(CGRect)frame
//{
//    NSString * string = [NSString stringWithFormat:@"x=%f,y=%f,w=%f,h=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
//    
//    KFLogDebug(string);
//}

- (void)addDefaultFileLog
{
    if (logFileManagerDefault == nil) {
        logFileManagerDefault = [[KFLogFileManagerDefault alloc] init];
    }
    
    if (fileLogger == nil) {
        fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManagerDefault];
        
        fileLogger.maximumFileSize  = 1024 * 1024;  // 1 MB
        fileLogger.rollingFrequency =   60 * 60;  // 60 Minute
        
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
        
        [fileLogger setLogFormatter:self];
        
        [DDLog addLogger:fileLogger];        
    }
}

- (void)removeFileLog
{
    if (fileLogger != nil) {
        [DDLog removeLogger:fileLogger];
        
        [fileLogger release];
        fileLogger = nil;
    }
}

- (void)addFileLogDirectory:(NSString *)aLogDirectory
            maximumFileSize:(NSUInteger)maximumFileSize
           rollingFrequency:(NSUInteger)rollingFrequency
    maximumNumberOfLogFiles:(NSUInteger)maximumNumberOfLogFiles
{
    if (logFileManagerDefault == nil) {
        logFileManagerDefault = [[KFLogFileManagerDefault alloc] init];
    }else{
        logFileManagerDefault = [[KFLogFileManagerDefault alloc] initWithLogsDirectory:aLogDirectory];
    }
    
    if (fileLogger == nil) {
        fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManagerDefault];
        
        fileLogger.maximumFileSize  = 1024 * 1024;  // 1 MB
        fileLogger.rollingFrequency =   60 * 60;  // 60 Minute
        
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
        
        [fileLogger setLogFormatter:self];
        
        [DDLog addLogger:fileLogger];
    }else{
        fileLogger.maximumFileSize  = maximumFileSize;  // 1 MB
        fileLogger.rollingFrequency =   rollingFrequency;  // 60 Minute
        
        fileLogger.logFileManager.maximumNumberOfLogFiles = maximumNumberOfLogFiles;
    }
}

@end
