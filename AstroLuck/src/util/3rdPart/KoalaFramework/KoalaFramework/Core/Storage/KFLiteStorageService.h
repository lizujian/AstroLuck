//
//  KFLiteStorageService.h
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/23/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFLiteStorageService : NSObject

// 获取单体
+ (KFLiteStorageService*)GetInstance;

// 清除对应用户的所有轻量级存储
- (void)clearWithUserID:(NSString*)userID;

// 清除默认用户的所有轻量级存储
- (void)clearDefaultUserLiteStorage;

// 清除全局用户的所有轻量级存储
- (void)cleaGlobalLiteStorage;

// 切换到指定用户存储
- (void)switchToUserID:(NSString*)userID;

// 切换到默认用户存储
- (void)switchToDefaultUserID;

// 获取当前用户存储
- (NSMutableDictionary*)getUserLiteStorage;

// 保存当前用户存储
- (void)saveUserLiteStorage;

// 获取全局用户存储
- (NSMutableDictionary*)getGlobalLiteStorage;

// 保存全局用户存储
- (void)saveGlobalLiteStorage;

// 版本控制函数
//- (void)versionControl;

// 存储版本升级
//- (void)upgrade;

@end
