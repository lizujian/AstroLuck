//
//  IDataParser.h
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-19.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Koala.h"

@interface IDataParser : NSObject

// 将请求参数映射到数据模型
-(void) mapRequestParam2DataModelClass:(KFRequestParameter *)requestParam
                     andDataModelClass:(Class)dataModelClass;

// 根据requestParam获取数据模型
-(Class) getParseClassFromRequestParam:(KFRequestParameter *)requestParam;

// 根据传入的请求参数和响应JSON数据，将该请求返回的响应JSON数据解析为数据模型（IDataModel)
-(id) parseDataFromJSON:(NSDictionary*)data
       withRequestParam:(KFRequestParameter *)requestParam;


// 单例模式定义
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(IDataParser);

@end
