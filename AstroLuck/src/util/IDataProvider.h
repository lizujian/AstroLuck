//
//  IDataProvider.h
//  Zhidao
//
//  Created by liangqiaozhong  on 13-1-11.
//  Copyright (c) 2013年 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameworkRelativeDefines.h"

@protocol  IManagerDelegate;
// 数据提供接口定义
@interface IDataProvider : NSObject

// 异步获取数据，返回请求Id
-(int64_t) asyncFetchData:(NSString *)dataURI
          withCachePolicy:(IDataCachePolicy)cachePolicy
       withDataParseClass:(Class)parseClass
         withDataDelegate:(id<IManagerDelegate>)delegate;

// 异步获取数据，返回请求Id（附加以Dictionary方式传递用户参数）
-(int64_t) asyncFetchDataWithUserInfo:(NSString *)dataURI
                             userInfo:(NSDictionary *)userInfo
                      withCachePolicy:(IDataCachePolicy)cachePolicy
                   withDataParseClass:(Class)parseClass
                     withDataDelegate:(id<IManagerDelegate>)delegate;

// 异步Post数据，返回请求Id
-(int64_t) asyncPostData:(NSString *)dataURI
              postValues:(NSDictionary *)postVaues
            postDataList:(NSArray *)dataArrays
                userInfo:(NSDictionary *)userInfo
      withDataParseClass:(Class)parseClass
        withDataDelegate:(id<IManagerDelegate>)delegate;

// 取消数据获取(或数据Post)请求（传入请求Id）
-(void) cancelFetchDataRequestByRequestID:(int64_t)requestId;

// 单例模式定义
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(IDataProvider)

@end
