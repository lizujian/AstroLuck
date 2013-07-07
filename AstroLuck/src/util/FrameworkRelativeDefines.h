//
//  CommonDefines.h
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-13.
//  Copyright (c) 2012 Baidu.com. All rights reserved.
//

#ifndef __FRAMEWORK_RELATIVE_DEFINES_H__
#define __FRAMEWORK_RELATIVE_DEFINES_H__


#define kSafeRelease(object) [object release],object=nil;
#define kInvalidRequestId   -1

// 离线缓存策略
typedef enum {
    IDataCachePolicyNetwork = 1, // 直接从网络获取
    IDataCachePolicyLocalFileAndNetwork = 2, // 从本地文件缓存获取，如果没有文件缓存，则从网络获取
    IDataCachePolicyLocalFile = 3, // 只从本地文件缓存获取
//    IDataCachePolicyOfflinePackageAndFileAndNetwork = 4, // 从离线下载包获取，如果没有，则判断是否有本地文件缓存，如果没有则从网络获取
    IDataCachePolicyDBCachedJson = 5, //从本地数据库中取JSON数据
} IDataCachePolicy;


//#import "SynthesizeSingleton.h"
#import "IDataModel.h"
#import "KFObjectExtension.h"
#import "IDataParser.h"
#import "IManagerBase.h"
#import "IDataProvider.h"
#import "ObjectException.h"
#import "UtilManager.h"
#import "UtilDefine.h"
//#import "ErrorDefines.h"

#endif
