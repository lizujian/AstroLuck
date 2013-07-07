//
//  IManager.h
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-13.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IManagerBase.h"

@interface IManager : IManagerBase

// 单例模式定义
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(IManager);

@end
