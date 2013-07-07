//
//  KFRuntimeDebug.m
//  KoalaFramework
//
//  Created by JHorn.Han on 12/12/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFRuntimeDebug.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <sys/errno.h>
#include <math.h>
#include <limits.h>
#include <objc/runtime.h>
#include <execinfo.h>

#define MAX_CALLSTACK_DEPTH	(64)

#pragma mark -

@interface CFFCllFrame(Private)
+ (NSUInteger)hex:(NSString *)text;
+ (id)parseFormat1:(NSString *)line;
+ (id)parseFormat2:(NSString *)line;
@end

#pragma mark -

@implementation CFFCllFrame

DEF_INT( TYPE_UNKNOWN,	0 )
DEF_INT( TYPE_OBJC,		1 )
DEF_INT( TYPE_NATIVEC,	2 )

@synthesize type = _type;
@synthesize process = _process;
@synthesize entry = _entry;
@synthesize offset = _offset;
@synthesize clazz = _clazz;
@synthesize method = _method;

- (NSString *)description
{
	if ( CFFCllFrame.TYPE_OBJC == _type )
	{
		return [NSString stringWithFormat:@"[O] %@(0x%08x + %d) -> [%@ %@]", _process, _entry, _offset, _clazz, _method];
	}
	else if ( CFFCllFrame.TYPE_NATIVEC == _type )
	{
		return [NSString stringWithFormat:@"[C] %@(0x%08x + %d) -> %@", _process, _entry, _offset, _method];
	}
	else
	{
		return [NSString stringWithFormat:@"[X] <unknown>(0x%08x + %d)", _entry, _offset];
	}
}

+ (NSUInteger)hex:(NSString *)text
{
	NSUInteger number = 0;
	[[NSScanner scannerWithString:text] scanHexInt:&number];
	return number;
}

+ (id)parseFormat1:(NSString *)line
{
    //	example: peeper  0x00001eca -[PPAppDelegate application:didFinishLaunchingWithOptions:] + 106
	NSError * error = NULL;
	NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+-\\[([a-z0-9_]+)\\s+([a-z0-9_:]+)]\\s+\\+\\s+([0-9]+)$";
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
	NSTextCheckingResult * result = [regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
	if ( result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges )
	{
		CFFCllFrame * frame = [[[CFFCllFrame alloc] init] autorelease];
		frame.type = CFFCllFrame.TYPE_OBJC;
		frame.process = [line substringWithRange:[result rangeAtIndex:1]];
		frame.entry = [CFFCllFrame hex:[line substringWithRange:[result rangeAtIndex:2]]];
		frame.clazz = [line substringWithRange:[result rangeAtIndex:3]];
		frame.method = [line substringWithRange:[result rangeAtIndex:4]];
		frame.offset = [[line substringWithRange:[result rangeAtIndex:5]] intValue];
		return frame;
	}
	
	return nil;
}

+ (id)parseFormat2:(NSString *)line
{
    //	example: UIKit 0x0105f42e UIApplicationMain + 1160
	NSError * error = NULL;
	NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+([a-z0-9_]+)\\s+\\+\\s+([0-9]+)$";
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
	NSTextCheckingResult * result = [regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
	if ( result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges )
	{
		CFFCllFrame * frame = [[[CFFCllFrame alloc] init] autorelease];
		frame.type = CFFCllFrame.TYPE_NATIVEC;
		frame.process = [line substringWithRange:[result rangeAtIndex:1]];
		frame.entry = [self hex:[line substringWithRange:[result rangeAtIndex:2]]];
		frame.clazz = nil;
		frame.method = [line substringWithRange:[result rangeAtIndex:3]];
		frame.offset = [[line substringWithRange:[result rangeAtIndex:4]] intValue];
		return frame;
	}
	
	return nil;
}

+ (id)unknown
{
	CFFCllFrame * frame = [[[CFFCllFrame alloc] init] autorelease];
	frame.type = CFFCllFrame.TYPE_UNKNOWN;
	return frame;
}

+ (id)parse:(NSString *)line
{
	if ( 0 == [line length] )
		return nil;
    
	id frame1 = [CFFCllFrame parseFormat1:line];
	if ( frame1 )
		return frame1;
	
	id frame2 = [CFFCllFrame parseFormat2:line];
	if ( frame2 )
		return frame2;
    
	return [CFFCllFrame unknown];
}

- (void)dealloc
{
	[_process release];
	[_clazz release];
	[_method release];
    
	[super dealloc];
}

@end

#pragma mark -

@implementation KFRuntimeDebug

+ (id)allocByClass:(Class)clazz
{
	if ( nil == clazz )
		return nil;
	
	return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName
{
	if ( nil == clazzName || 0 == [clazzName length] )
		return nil;
	
	Class clazz = NSClassFromString( clazzName );
	if ( nil == clazz )
		return nil;
	
	return [clazz alloc];
}

+ (NSArray *)callstack:(NSUInteger)depth
{
	NSMutableArray * array = [[[NSMutableArray alloc] init] autorelease];
	
	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
    
	depth = backtrace( stacks, (depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth );
	if ( depth > 1 )
	{
		char ** symbols = backtrace_symbols( stacks, depth );
		if ( symbols )
		{
			for ( int i = 0; i < (depth - 1); ++i )
			{
				NSString * symbol = [NSString stringWithUTF8String:(const char *)symbols[1 + i]];
				if ( 0 == [symbol length] )
					continue;
                
				NSRange range1 = [symbol rangeOfString:@"["];
				NSRange range2 = [symbol rangeOfString:@"]"];
                
				if ( range1.length > 0 && range2.length > 0 )
				{
					NSRange range3;
					range3.location = range1.location;
					range3.length = range2.location + range2.length - range1.location;
					[array addObject:[symbol substringWithRange:range3]];
				}
				else
				{
					[array addObject:symbol];
				}
			}
            
			free( symbols );
		}
	}
	
	return array;
}

+ (NSArray *)callframes:(NSUInteger)depth
{
	NSMutableArray * array = [[[NSMutableArray alloc] init] autorelease];
	
	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
	
	depth = backtrace( stacks, (depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth );
	if ( depth > 1 )
	{
		char ** symbols = backtrace_symbols( stacks, depth );
		if ( symbols )
		{
			for ( int i = 0; i < (depth - 1); ++i )
			{
				NSString * line = [NSString stringWithUTF8String:(const char *)symbols[1 + i]];
				if ( 0 == [line length] )
					continue;
                
				CFFCllFrame * frame = [CFFCllFrame parse:line];
				if ( nil == frame )
					continue;
				
				[array addObject:frame];
			}
			
			free( symbols );
		}
	}
	
	return array;
}

+ (void)printCallstack:(NSUInteger)depth
{
	NSArray * callstack = [self callstack:depth];
	if ( callstack && callstack.count )
	{
		NSLog(@"RuntimeDebugStack:%@",callstack);
	}
}

@end
