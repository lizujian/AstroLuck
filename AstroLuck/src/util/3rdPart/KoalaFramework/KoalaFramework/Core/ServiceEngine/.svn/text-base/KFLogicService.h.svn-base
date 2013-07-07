//
//  KFLogicService.h
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/23/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KFDataProvider.h"

@interface KFLogicService : NSObject

// 获取单体
+ (KFLogicService*)GetInstance;

// 取消seqID对应的请求
- (void)cancelWithSeqID:(int64_t)seqID;

// 统一发送接口
- (int64_t)_sendReuqestWithDataProvider:(KFDataProvider*)provider;

@end
