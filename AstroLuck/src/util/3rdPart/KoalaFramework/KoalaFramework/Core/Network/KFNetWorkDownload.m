//
//  KFNetWorkDownoad.m
//  KoalaFramework
//
//  Created by JHorn.Han on 10/29/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFNetWorkDownload.h"
#import "ASIHTTPRequest.h"
#import "KFRequestConfig.h"
#import "KFImageDownloadCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface KFNetWorkDownload() {
    // 请求任务队列
    NSOperationQueue *_queue;
    
    // 临时队列
    NSMutableArray *_temQueue;
    
    // 请求数目
    int64_t _requestCount;
}
@property(nonatomic,assign)int64_t requestCount;
@property(nonatomic,retain) NSMutableArray *temQueue;
@property(nonatomic,retain) NSOperationQueue *queue;


@end

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KFNetWorkDownload);
@implementation KFNetWorkDownload
SYNTHESIZE_SINGLETON_FOR_CLASS(KFNetWorkDownload)

@synthesize requestCount = _requestCount;
@synthesize temQueue = _temQueue;
@synthesize queue = _queue;
@synthesize maxOperationCount = _maxOperationCount;
@synthesize timeOut = _timeOut;

- (NSString *)cachePathForKey:(ASIHTTPRequest *)key
{
    
    NSString *extension = [[[key url] path] pathExtension];
    
	if (![extension length]) {
		extension = @"html";
	}
    const char *str = [key.url.path UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    
    return [filename stringByAppendingPathExtension:extension];
}


-(void)addRequest:(KFDownLoadRequestParameter*)paramReq
         delegate:(id<KFNetWorkDownoadDelegate>) delegate {
    
    if(self.queue == nil || !paramReq || !paramReq.url) {
        paramReq.requestID = -1;
        return;
    }
    
    
    NSCondition *mylock = [[NSCondition alloc] init];
    [mylock lock];
    {
        if(paramReq.url == nil) {
            
            [mylock unlock];
            [mylock release];
            return;
        }
        
        paramReq.method = @"DOWN";
        ASIHTTPRequest* http = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:paramReq.url]];
        [http setDelegate:self];
        [http setDownloadProgressDelegate:self];
        [http setShowAccurateProgress:YES];
        [http setQueuePriority:paramReq.requestPriority];
       // [http setQueuePriority:(NSOperationQueuePriority)]
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString* cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask
                                                                        , YES) objectAtIndex:0];
        
        if(paramReq.downloadDestinationPath == nil) {
            
            NSString* path = [documentsDirectory stringByAppendingPathComponent:[self cachePathForKey:http]];
            KFLog(@"Downloadpath = %@",path);
            [paramReq setDownloadDestinationPath:path];
        }
        if(paramReq.tempDownloadDir == nil) {
             NSString* path = [cacheDirectory stringByAppendingPathComponent:[self cachePathForKey:http]];
            path = [path stringByAppendingString:@".tmp"];
            KFLog(@"DownLoadCachepath = %@",path);
            [paramReq setTempDownloadDir:path];
        }
        
     //   [http setDownloadProgressDelegate:delegate];
        [http setShowAccurateProgress:YES];
        [http setDownloadDestinationPath:paramReq.downloadDestinationPath];
        [http setTemporaryFileDownloadPath:paramReq.tempDownloadDir];
        [http setAllowResumeForFileDownloads:YES];
//        if([[KFRequestConfig sharedInstance] tokenToCookie]) {
//            [http setRequestCookies:KFNetReqCookies];
//        }
//        
//        [http setAllowCompressedResponse:self.supportCompressedData];
        
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        http.userInfo = d;
        [d release];
        
        [d setValue:delegate forKey:DELEGATE_KEY];
        [d setValue:paramReq forKey:REQ_Param];
        
        int64_t requestId = self.requestCount ++ ;
        paramReq.requestID = requestId;
        [d setValue:[NSNumber numberWithUnsignedLongLong:requestId] forKey:REQID_KEY];
        [d setValue:paramReq.dataFormat forKey:RETURN_DATA_TYPE_KEY];
 //       [http setTimeOutSeconds:self.timeOut];
        [http setDelegate:self];
        [self.temQueue addObject:http];

        
    }
    [mylock unlock];
    [mylock release];
}

-(id)requestForID:(int64_t)reqId
{
    int count = [self.temQueue count];
    for(int64_t i = 0; i < count; i++) {
        ASIHTTPRequest *request = (ASIHTTPRequest *)[self.temQueue objectAtIndex:i];
        NSDictionary *userInfo = request.userInfo;
        if([[userInfo objectForKey:REQID_KEY] unsignedIntValue] == reqId) {
            return request;
        }
    }
    return nil;
}

-(id)requestForParam:(KFDownLoadRequestParameter*)param {
    
    int count = [self.temQueue count];
    for(int64_t i = 0; i < count; i++) {
        ASIHTTPRequest *request = (ASIHTTPRequest *)[self.temQueue objectAtIndex:i];
        NSDictionary *userInfo = request.userInfo;
        if([userInfo objectForKey:REQ_Param] == param) {
            return request;
        }
    }
    return nil;
}

-(void)startReqForParam:(KFDownLoadRequestParameter*)param {
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    ASIHTTPRequest *request = [self requestForParam:param];
    
    if(request) {
        //NSDictionary* userinfo = request.userInfo;
        [self.queue addOperation:request];
        [self.temQueue removeObject:request];
    }
}

-(void)startReqForId:(int64_t)reqId
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    ASIHTTPRequest *request = [self requestForID:reqId];
    
    if(request) {
        //NSDictionary* userinfo = request.userInfo;
        [self.queue addOperation:request];
        [self.temQueue removeObject:request];
    }
}

-(void)pauseReqForParam:(KFDownLoadRequestParameter*)param
{
    NSArray *array =  self.queue.operations;
    if(array == nil)
    {
        return ;
    }
    int count = [array count];
    for(int64_t i = 0; i < count; i++)
    {
        ASIHTTPRequest * request = (ASIHTTPRequest *)[array objectAtIndex:i];
        NSDictionary *userInfo = request.userInfo;
        if([userInfo objectForKey:REQ_Param] == param)
        {
            [request clearDelegatesAndCancel];
            param.downloadStatus = DownloadPause;
            break;
        }
    }
}


#pragma mark delegate downloadProgressdelegate

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    
   // ASIHTTPRequest *request = (ASIHTTPRequest *)sender;
    id del = nil;
    //    int iState = [request responseStatusCode];
    if(!request ||
       !request.userInfo ||
       !(del = [request.userInfo objectForKey:DELEGATE_KEY])) {
        return;
    }
    
    NSDictionary* userinfo = request.userInfo;
    KFDownLoadRequestParameter* param = [userinfo objectForKey:REQ_Param];
    param.totalSize = request.contentLength;
    KFLog(@"total size = %lld",param.totalSize);
    param.downloadStatus = Downloading;
    if([del respondsToSelector:@selector(networkDownloadDidStart:)]) {
        [del networkDownloadDidStart:param];
    }
    
//    KFLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
//    
//    KFLog(@"contentlength=%f",request.contentLength/1024.0/1024.0);
//    int bookid = [[request.userInfo objectForKey:@"bookID"] intValue];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    float tempConLen = [[userDefaults objectForKey:[NSString stringWithFormat:@"book_%d_contentLength",bookid]] floatValue];
//    KFLog(@"tempConLen=%f",tempConLen);
//    //如果没有保存,则持久化他的内容大小
//    if (tempConLen == 0 ) {//如果没有保存,则持久化他的内容大小
//        [userDefaults setObject:[NSNumber numberWithFloat:request.contentLength/1024.0/1024.0] forKey:[NSString stringWithFormat:@"book_%d_contentLength",bookid]];
//    }

}


- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    KFLog(@"will RediectToURL");
}


- (void)requestFinished:(ASIHTTPRequest *)request {

    // ASIHTTPRequest *request = (ASIHTTPRequest *)sender;
    id del = nil;
    //    int iState = [request responseStatusCode];
    if(!request ||
       !request.userInfo ||
       !(del = [request.userInfo objectForKey:DELEGATE_KEY])) {
        return;
    }
    
    NSDictionary* userinfo = request.userInfo;
    KFDownLoadRequestParameter* param = [userinfo objectForKey:REQ_Param];
    param.downloadStatus = DownloadFinish;
    if([del respondsToSelector:@selector(networkDownloadDidFinished:)]) {
        [del networkDownloadDidFinished:param];
    }
    
     KFLog(@"Request Finished");
}


- (void)requestFailed:(ASIHTTPRequest *)request {

     KFLog(@"Request Failed");
    
    NSError *error = [request error];
   // [_controlButton setTitle:@"Fail" forState:UIControlStateNormal];
    KFLog(@"Failed error : %@", [error localizedDescription]);
    
    id del = nil;
    //    int iState = [request responseStatusCode];
    if(!request ||
       !request.userInfo ||
       !(del = [request.userInfo objectForKey:DELEGATE_KEY])) {
        return;
    }
    
    NSDictionary *resp = [request responseHeaders];
    NSString *redirectURL = [resp valueForKey:@"Location"];
    if([request responseStatusCode] == 302 && redirectURL){
   //     [self redirectToDest:redirectURL];
    }
    
    NSDictionary* userinfo = request.userInfo;
    
    KFDownLoadRequestParameter* param = [userinfo objectForKey:REQ_Param];
     param.downloadStatus = DownloadPause;
    if([del respondsToSelector:@selector(networkDownloadDidFailed:)]) {
        [del networkDownloadDidFailed:param];
    }
}
- (void)requestRedirected:(ASIHTTPRequest *)request {
}



- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    
    KFLog(@"recv bytes = %lld",bytes);
    id del = nil;
    //    int iState = [request responseStatusCode];
    if(!request ||
       !request.userInfo ||
       !(del = [request.userInfo objectForKey:DELEGATE_KEY])) {
        return;
    }
    
    NSDictionary* userinfo = request.userInfo;
    KFDownLoadRequestParameter* param = [userinfo objectForKey:REQ_Param];
    param.curSize += bytes;
    if([del respondsToSelector:@selector(networkDownloadDownloading:)]) {
        [del networkDownloadDownloading:param];
    }
}



-(void) setMaxOperationCount:(NSInteger)maxOperationCount {
    _queue.maxConcurrentOperationCount = _maxOperationCount = maxOperationCount;
}

-(id)init {
    
    if(self = [super init]) {
        if(_temQueue){
            self.temQueue = nil;
        }
        
        if(_queue){
            [self.queue cancelAllOperations];
            self.queue = nil;
        }
        
        self.maxOperationCount = MAX_CUR_OPERATION_COUNT;
        self.timeOut = MAX_REQUEST_TIME_OUT;
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = self.maxOperationCount;
        _temQueue = [[NSMutableArray alloc] init];
        _requestCount = 0x0001;
        
        
       // [self setShouldRespectCacheControl:NO];
        //
        
        
    }

    
    return self;
}

-(void)dealloc {

    self.queue = nil;
    self.temQueue = nil;
    
    [super dealloc];
}

@end
