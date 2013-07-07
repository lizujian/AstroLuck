//
//  IManagerBase.h
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-19.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FrameworkRelativeDefines.h"
#import "KFObjectExtension.h"
#import "IDataParser.h"
#import "IManagerBase.h"
#import "IDataProvider.h"
#import "IDataModel.h"

@protocol IManagerDelegate <NSObject>

@optional
-(void) updateViewForSuccess:(IDataModel *)dataModel
               withRequestId:(int64_t)requestId;
-(void) updateViewForSuccess:(IDataModel *)dataModel
            withRequestParam:(id)requestParam;
-(void) updateViewForError:(NSError *)errorInfo
             withRequestId:(int64_t)requestId;
-(void) updateViewForError:(NSError *)errorInfo
          withRequestParam:(id)requestParam;

@end


@interface IManagerBase : NSObject

@property(nonatomic,assign) BOOL isIOS5;

// 取消数据获取(或数据Post)请求（传入请求Id）
-(void) cancelFetchDataRequestByRequestID:(int64_t)requestId;

@end
