//
//  IManager.m
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-13.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import "IManager.h"
#import "Koala.h"
//#import "CommonDefines.h"
#import "FrameworkRelativeDefines.h"
#import "IDataParser.h"
#import "IDataProvider.h"


@interface IManager()
{    
}

@end

// 单例模式类别
SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(IManager)

@implementation IManager

#pragma mark -
#pragma mark 对象初始化

// 单例模式实现
SYNTHESIZE_SINGLETON_FOR_CLASS(IManager)

-(id) init
{
    self = [super init];
    if ( self == nil ) 
        return self;
    
    // 在此进行初始化定义
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


@end
