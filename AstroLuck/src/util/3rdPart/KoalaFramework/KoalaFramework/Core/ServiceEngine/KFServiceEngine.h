//
//  KFServiceEngine.h
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/23/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFDatabaseService.h"
#import "KFLiteStorageService.h"
#import "KFLogicService.h"

@interface KFServiceEngine : NSObject

+ (KFServiceEngine*)GetInstance;

// 数据库操作服务
+ (KFDatabaseService*)DatabaseService;

// 轻量级存储服务
+ (KFLiteStorageService*)LiteStorageService;

// 业务请求服务
+ (KFLogicService*)LogicService;

// 推送服务
//+ (KFPushService*)PushService;

@end
