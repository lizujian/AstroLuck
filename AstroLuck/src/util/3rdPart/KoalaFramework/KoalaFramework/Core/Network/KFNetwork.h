//
//  KFNetwork.h
//  KoalaFramework
//
//  Created by Daly on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "KFRequestParameter.h"




/* use ->
 
 ...............error code ..........................
    
 
    1 @"网络链接不上",
    2 @"网络链接超时";
    3 @"链接认证失败";,
    4 @"链接认证失败";
    5 @"请求已经被取消";

    10001  返回数据为空
    10002  收到了数据但是解析json数据失败
    10003  request image file failed
 
 
 ...............file.mm method -> ...................
 
 @
 KFRequestParameter* param = [KFRequestParameter requestParamWithURL:@"http://guangjie.hao123.com/m/gethot?offset=1&count=100"];
 [[KFNetwork sharedInstance] addRequest:param
 delegate:self];
 
 [[KFNetwork sharedInstance]startReqForParam:param];
 @
 
 
 ...............delegate call -> .....................
 
 @
 -(void)networkDidFinished:(KFNetwork*)aNetwork 
                requestParam:(KFRequestParameter*)param
                        data:(id)data 
 {
    self.requestLabel.text = [NSString stringWithFormat:@"request = %lld",param.requestID];
    NSLog(@"requet = %lld",param.requestID);
 
 }
 
 
 -(void)networkDidFailed:(KFNetwork*)aNetwork 
            requestParam:(KFRequestParameter*)param
                    error:(NSError*)error {
    int errorcode = error.code;
    NSLog(@"[*Error* request = %lld] %@",param.requestID,error);
 }
 @
 
*/


#define MAX_CUR_OPERATION_COUNT 10
#define DELEGATE_KEY @"delegateKey"
#define SUCC_BLOCK @"SUCCBLOCK"
#define FAILED_BLOCK @"FAILEDBLOCK"
#define REQID_KEY @"reqIdKey"
#define REQ_Param @"REQ_Param"
#define RETURN_DATA_TYPE_KEY @"returnTypeKey"
#define MAX_REQUEST_TIME_OUT 25
#import "KFRequestCodeSignerDelegate.h"

#define KFNINST [KFNetwork sharedInstance]

@class KFNetwork;

@protocol KFNetworkDelegate <NSObject>

@optional
-(void)networkDidFinished:(KFNetwork*)aNetwork  requestParam:(KFRequestParameter*)param data:(id)data;
-(void)networkDidFailed:(KFNetwork*)aNetwork requestParam:(KFRequestParameter*)param error:(NSError*)error;
@end

@interface KFNetwork : NSObject {
    
    // 最大并发的Http数目，设置为 1 为顺序执行所有请求 默认 ： MAX_CUR_OPERATION_COUNT 10。
    NSInteger _maxOperationCount;
    
    // 最大超时时间默认 25 秒
    NSTimeInterval _timeOut;
        
    // 是否接受 GZIP 数据压缩 默认接受：YES
    BOOL _supportCompressedData;
    
    //编码默认 UTF－8
    NSStringEncoding _encoding;
    
    
    // NO: 忽略服务器”请勿缓存“的声明， cache-control pragma: no-cache，
    // 在这里我们默认打开为NO, 忽略服务器对数据缓存的限制。
    BOOL _shouldRespectCacheControl;
    
    
    //设置默认的缓存类（URL缓存）,如果需要自定自己的缓存类 请派生 KFUrlDownloadCache
    id _defaultUrlDownloadCache;
    
    
    //设置默认的缓存类（Image缓存）如果需要自定自己的缓存类 请派生 KFImageDownloadCache
    id _defaultImageDownLoadCache;
    
    
    id<KFRequestCodeSignerDelegate> _codesinger;
}

@property(nonatomic,assign) BOOL supportCompressedData;
@property(nonatomic,assign) NSStringEncoding encoding;
@property(nonatomic,assign) NSInteger maxOperationCount;
@property(nonatomic,assign) NSTimeInterval timeOut;
@property(nonatomic,assign) BOOL shouldRespectCacheControl;
@property(nonatomic,retain) id defaultUrlDownloadCache;
@property(nonatomic,retain) id defaultImageDownLoadCache;
@property(nonatomic,retain) id<KFRequestCodeSignerDelegate> codesinger;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KFNetwork);

-(void)clearUrlCahce;
-(void)clearImageDownCache;

-(void)addRequest:(KFRequestParameter*)paramReq
         delegate:(id<KFNetworkDelegate>) delegate;

-(void)startReqForId:(int64_t)reqId;


-(void)startReqForParam:(KFRequestParameter*)param;

-(void)startReqForParam:(KFRequestParameter *)param
              succBlock:(void(^)(id data))succcall
            failedBlock:(void(^)(id data))failcall;

-(void)cancelForReqParam:(KFRequestParameter*)param;
-(void)cancelForReqId:(int64_t)reqId;

-(void)cancelAll;
-(void)setSuspended:(BOOL)b;

-(BOOL)isSuppended;
@end
