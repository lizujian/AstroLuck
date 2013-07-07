//
//  KFRuntimeCrashReporter.m
//  KoalaFramework
//
//  Created by JHorn.Han on 12/14/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFRuntimeCrashReporter.h"
#import "KFRuntimeDebug.h"
#import "JSONKit.h"

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KFRuntimeCrashReporter);

#pragma mark -

@interface KFRuntimeCrashReporter(Private)
- (void)installSignal:(int)signal;
- (void)saveException:(NSException *)exception;
- (void)saveSignal:(int)signal info:(siginfo_t *)info;
- (void)saveInfo:(NSDictionary *)dict;
@end

#pragma mark -

@implementation KFRuntimeCrashReporter

@synthesize installed = _installed;
@synthesize logPath = _logPath;

SYNTHESIZE_SINGLETON_FOR_CLASS( KFRuntimeCrashReporter )

static void signalHandler( int signal )
{
	[[KFRuntimeCrashReporter sharedInstance] saveSignal:signal info:NULL];
    
	raise( signal );
}

static void exceptionHandler( NSException * exception )
{
	[[KFRuntimeCrashReporter sharedInstance] saveException:exception];
	
	abort();
}

- (void)saveException:(NSException *)exception
{
	NSMutableDictionary * detail = [NSMutableDictionary dictionary];
	if ( exception.name )
	{
		[detail setObject:exception.name forKey:@"name"];
	}
	if ( exception.reason )
	{
		[detail setObject:exception.reason forKey:@"reason"];
	}
	if ( exception.userInfo )
	{
		[detail setObject:exception.userInfo forKey:@"userInfo"];
	}
	if ( exception.callStackSymbols )
	{
		[detail setObject:exception.callStackSymbols forKey:@"callStack"];
	}
    
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:@"exception" forKey:@"type"];
	[dict setObject:[NSNumber numberWithInt:(0)] forKey:@"code"];
	[dict setObject:detail forKey:@"info"];
	
	[self saveInfo:dict];
}

- (void)saveSignal:(int)signal info:(siginfo_t *)info
{
	NSArray * stack = [KFRuntimeDebug callstack:32];
    
	NSMutableDictionary * detail = [NSMutableDictionary dictionary];
	[detail setObject:stack forKey:@"callStack"];
    
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:@"signal" forKey:@"type"];
	[dict setObject:[NSNumber numberWithInt:(signal)] forKey:@"code"];
	[dict setObject:detail forKey:@"info"];
    
	[self saveInfo:dict];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	NSUInteger timeUint = (NSUInteger)time;
	return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
	
#else
	
	// thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:[NSDate date]];
	
#endif
}

+ (NSUInteger)timeStamp
{
	NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
	return (NSUInteger)(time * 1000.0f);
}


- (void)saveInfo:(NSDictionary *)dict
{
	NSString * fileName = [self stringWithDateFormat:@"yyyyMMdd_HHmmss"];
	NSString * fullName = [self.logPath stringByAppendingString:fileName];
    
	NSError * error = nil;
    
    
    NSLog(@"KFCrashReport = %@",dict);
	BOOL succeed = [[dict JSONData] writeToFile:fullName options:NSDataWritingAtomic error:&error];
	if ( NO == succeed )
	{
		NSLog(@"%@",[error description]);
	}
}


- (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.logPath = [NSString stringWithFormat:@"%@/KFCrashLog/", [self libCachePath]];
        NSLog(@"crash report fileKF = %@",self.logPath);
		if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:self.logPath] )
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:self.logPath
									  withIntermediateDirectories:YES
													   attributes:nil
															error:NULL];
		}
	}
	return self;
}

- (void)dealloc
{
	[_logPath release];
	
	signal( SIGABRT,	SIG_DFL );
	signal( SIGBUS,		SIG_DFL );
	signal( SIGFPE,		SIG_DFL );
	signal( SIGILL,		SIG_DFL );
	signal( SIGPIPE,	SIG_DFL );
	signal( SIGSEGV,	SIG_DFL );
	
	[super dealloc];
}

- (void)install
{
	if ( _installed )
		return;
	
	signal( SIGABRT,	&signalHandler );
    signal( SIGBUS,		&signalHandler );
    signal( SIGFPE,		&signalHandler );
    signal( SIGILL,		&signalHandler );
    signal( SIGPIPE,	&signalHandler );
    signal( SIGSEGV,	&signalHandler );
    
	NSSetUncaughtExceptionHandler( &exceptionHandler );
}

@end