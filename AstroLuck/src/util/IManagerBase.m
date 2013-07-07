//
//  IManagerBase.m
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-19.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import "IManagerBase.h"
#import "IDataProvider.h"

@implementation IManagerBase
@synthesize isIOS5=_isIOS5;

#pragma mark -
#pragma mark 对象初始化

-(id) init
{
    self = [super init];
    if ( self == nil ) 
        return self;
    
    _isIOS5 = [[[UIDevice currentDevice]systemVersion]intValue] >=5? YES:NO;
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


// 取消数据获取(或数据Post)请求（传入请求Id）
-(void) cancelFetchDataRequestByRequestID:(int64_t)requestId
{
    [[IDataProvider sharedInstance] cancelFetchDataRequestByRequestID:requestId];
}

@end

