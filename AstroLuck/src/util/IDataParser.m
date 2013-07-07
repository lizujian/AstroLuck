//
//  IDataParser.m
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-19.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import "IDataParser.h"
#import "FrameworkRelativeDefines.h"
#import "IDataModel.h"

#define kMaxMapRequestParam2ParseClass 1000

@interface IDataParser()
{
    NSMutableDictionary *_mapRequestParam2ParseClass;
}
@end

// 单例模式类别
SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(IDataParser)

@implementation IDataParser

// 单例模式实现
SYNTHESIZE_SINGLETON_FOR_CLASS(IDataParser)

// 初始化
-(id) init
{
    self = [super  init];
    if ( nil == self )
        return nil;
    
    // 在此进行初始化定义
    _mapRequestParam2ParseClass = [[NSMutableDictionary alloc] initWithCapacity:kMaxMapRequestParam2ParseClass];
    
    return self;
}

-(void) dealloc
{
    [_mapRequestParam2ParseClass removeAllObjects];
    kSafeRelease(_mapRequestParam2ParseClass)
    [super dealloc];
}


// 将请求参数映射到数据模型
-(void) mapRequestParam2DataModelClass:(KFRequestParameter *)requestParam andDataModelClass:(Class)dataModelClass
{
    if ( nil == _mapRequestParam2ParseClass )
        return;
    //chenwh %ld -> %lld
    [_mapRequestParam2ParseClass setObject:dataModelClass forKey:[NSString stringWithFormat:@"%lld",requestParam.requestID]];
}


// 根据requestParam获取数据模型
-(Class) getParseClassFromRequestParam:(KFRequestParameter *)requestParam
{   
    if ( nil == _mapRequestParam2ParseClass )
        return nil;
    
    //chenwh %ld -> %lld
    NSString *stringKey = [NSString stringWithFormat:@"%lld",requestParam.requestID];
    if ( !stringKey ) return nil;
    Class dataModelClass = (Class)[_mapRequestParam2ParseClass objectForKey:stringKey];
    return dataModelClass;
}


/// 根据传入的请求参数和响应JSON数据，将该请求返回的响应JSON数据解析为数据模型（IDataModel)
-(id) parseDataFromJSON:(NSDictionary*)data withRequestParam:(KFRequestParameter *)requestParam
{
    // 输入参数判断
    if ( nil == data || nil == requestParam )
        return nil;
    
    // 根据requestParam获取数据模型类
    Class dataModelClass = [self getParseClassFromRequestParam:requestParam];
    if ( nil == dataModelClass )
        return nil;

    // 解析数据模型
//    IDataModel *dataModelClazz = [dataModelClass new];
    // 根据param的userInfo设置离线包标识isDataFromOfflinePackage
//    NSString *offlineName = [requestParam.userInfo stringValueForKey:@"isDataFromOfflinePackage" defaultValue:nil operation:NSStringOperationTypeTrim];
//    dataModelClazz.isDataFromOfflinePackage = (nil == offlineName)?NO:YES;
//    dataModelClazz.userInfo = requestParam.userInfo;
    IDataModel *dataModel = [dataModelClass parseDataFromJSON:data];
//    [dataModelClazz dealloc];
    
    return dataModel;
}

@end
