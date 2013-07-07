//
//  KFNetWorkDownoad.h
//  KoalaFramework
//
//  Created by JHorn.Han on 10/29/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFNetwork.h"
#import "KFDownLoadRequestParameter.h"
#import "SynthesizeSingleton.h"



@protocol KFNetWorkDownoadDelegate <NSObject>

@optional
-(void)networkDownloadDidStart:(KFDownLoadRequestParameter*)par;
-(void)networkDownloadDidFinished:(KFDownLoadRequestParameter*)par;
-(void)networkDownloadDidFailed:(KFDownLoadRequestParameter*)par;
-(void)networkDownloadDownloading:(KFDownLoadRequestParameter*)par;
//-(void)networkDownloadDownloading:(KFDownLoadRequestParameter*)par;
@end

@interface KFNetWorkDownload :  NSObject {
    
    // 最大并发的Http数目，设置为 1 为顺序执行所有请求 默认 ： MAX_CUR_OPERATION_COUNT 10。
    NSInteger _maxOperationCount;
    
    // 最大超时时间默认 25 秒
    NSTimeInterval _timeOut;
}


@property(nonatomic,assign) NSInteger maxOperationCount;
@property(nonatomic,assign) NSTimeInterval timeOut;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KFNetWorkDownload);



-(void)addRequest:(KFDownLoadRequestParameter*)paramReq
         delegate:(id<KFNetWorkDownoadDelegate>) delegate;

-(void)startReqForParam:(KFDownLoadRequestParameter*)param;

-(void)startReqForId:(int64_t)reqId;

-(void)pauseReqForParam:(KFDownLoadRequestParameter*)param;
@end
