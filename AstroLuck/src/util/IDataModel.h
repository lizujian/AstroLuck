//
//  IDataModel.h
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-13.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Define.h"

#ifndef USE_SIMULATION_DATA
//#define USE_SIMULATION_DATA
#endif

@interface IDataModel : NSObject

// 将JSON数据解析为数据模型,此处为空实现，需要具体的IDataModel子类重载实现
//- (id)parseDataFromJSON:(NSDictionary*)data;
+ (id)parseDataFromJSON:(NSDictionary*)data;
- (void)buildSimulationData;
- (NSDictionary *)dictionaryRepresentation;
- (void) saveInDB;
//@property(nonatomic, assign) BOOL isDataFromOfflinePackage; // 数据模型是否来自离线下载包
//@property(nonatomic, retain) NSString *jsonValue;
//@property(nonatomic, retain) NSString *dbKey;               // 在数据库中索引的KEY
//@property(nonatomic, assign) BOOL isDataFromDB;             // 数据模型是否从本地数据库中来
//@property(nonatomic,retain) NSDictionary *userInfo;         // 请求时传入的参数，可以在IManager的asyncFetchDataWithUserInfo接口传递userInfo参数，在网络请求返回时访问该参数，以便处理一些在网络请求返回时需要用到请求参数的情况
@end
