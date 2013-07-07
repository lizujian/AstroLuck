//
//  NSObject+performSelectorOnMainThreadWithMultiArguments.m
//  BaiduTravel
//
//  Created by liangqiaozhong on 13-3-19.
//  Copyright (c) 2013年 Baidu.com. All rights reserved.
//

#import "NSObject+performSelectorOnMainThreadWithMultiArguments.h"

@implementation NSObject(performSelectorOnMainThreadWithMultiArguments)

-(void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 withObject:(id)arg3 waitUntilDone:(BOOL)wait
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig) return;
    
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&arg1 atIndex:2];
    [invo setArgument:&arg2 atIndex:3];
    [invo setArgument:&arg3 atIndex:4];
    [invo retainArguments];
    [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

@end
