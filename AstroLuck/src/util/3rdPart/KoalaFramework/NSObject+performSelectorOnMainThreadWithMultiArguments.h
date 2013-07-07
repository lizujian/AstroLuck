//
//  NSObject+performSelectorOnMainThreadWithMultiArguments.h
//  BaiduTravel
//
//  Created by liangqiaozhong on 13-3-19.
//  Copyright (c) 2013年 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(performSelectorOnMainThreadWithMultiObject)

-(void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 withObject:(id)arg3 waitUntilDone:(BOOL)wait;

@end
