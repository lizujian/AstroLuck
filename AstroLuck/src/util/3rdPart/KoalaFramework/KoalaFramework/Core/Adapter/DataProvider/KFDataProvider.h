//
//  KFDataProvider.h
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/25/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFDatabaseService.h"
#import "KFRequestParameter.h"
#import "KFNetwork.h"
#import "KFCommon.h"
@interface KFDataProvider : KFRequestParameter <KFDatabaseDelegate> {
    KFCacheRule _cacheRule;   // 离线缓存策略
    NSString   *_type;        // 数据库表名
    Class       _parserClass; // 数据解析类的类型
    
    NSMutableArray *_keyConfigureArray;   // <name, type> pair for db storage
    NSMutableArray *_valueConfigureArray; // <name, type> pair for db storage
}

@property (nonatomic) KFCacheRule cacheRule;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) Class parserClass;

// 所有参数配置完整后必须调用, 此时 requestID 被赋值
- (void)addRequestWithDelegate:(id<KFNetworkDelegate>)delegate;

// 初始化离线缓存配置
- (void)initCacheDBConfigure;

// 本地获取数据函数
- (BOOL)KFCacheRuleLocalMethod;

// 从本地获取数据，不满足条件时从网络获取数据
- (BOOL)KFCacheRuleLocalAndNetworkMethod;

// 从网络获取数据
- (BOOL)KFCacheRuleNetworkMethod;

// 取消请求
- (void)cancelRequest;

// 发送请求
- (int64_t)sendRequest;

// 是否从网络请求，调用过程中引入离线缓存函数
- (BOOL)isFromNetwork;

@end
