//
//  KFNetwork.m
//  KoalaFramework
//
//  Created by Daly on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "KFNetwork.h"
#import "KFDataParser.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "KFRequestConfig.h"
#import "JSONKit.h"
#import "KFUrlDownloadCache.h"
#import "KFImageDownloadCache.h"
#import "KFLogTool.h"
#import "KFRequestCodeSigner.h"
#import "NSObject+performSelectorOnMainThreadWithMultiArguments.h"


#define NetWorkInstance [KFNetwork sharedInstance] 

#define POST_BOBY_DATA_DATA @"postBobyData"
#define POST_BOBY_DATA_KEY  @"postBobyDataKey"
#define POST_BOBY_DATA_FILE_NAME  @"postBobyDataFileName"
#define POST_BOBY_DATA_CONTENT_TYPE  @"postBobyDataContentType"



@interface KFNetwork() {
    // 请求任务队列
    NSOperationQueue *_queue;
    
    // 临时队列
    NSMutableArray *_temQueue;
    
    // 请求数目
    u_int64_t _requestCount;
    
    NSRecursiveLock* _jhornLock;
}
@property(nonatomic,assign)u_int64_t requestCount;
@property(nonatomic,retain) NSMutableArray *temQueue;
@property(nonatomic,retain) NSOperationQueue *queue;
@property(nonatomic,retain) NSRecursiveLock* jhornLock;

+(BOOL)createDirectory:(NSString*)path ;


-(void)toDictOrData:(ASIHTTPRequest*)request
               parm:(KFRequestParameter*)param
            retType:(NSString*)returnType
          succBlock:(void(^)(id data))succcall
        failedBlock:(void(^)(id data))failcall;


-(void)toJson:(ASIHTTPRequest*)request
         parm:(KFRequestParameter*)param
    succBlock:(void(^)(id data))succcall
  failedBlock:(void(^)(id data))failcall;
@end


SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KFNetwork);
static NSString *_KFImageCacheDirectory;
static NSString *_KFURLCacheDirectory; 


static inline NSString *KFImageCacheDirectory() {
	if(!_KFImageCacheDirectory) {
        
        
		_KFImageCacheDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:KFNetworkCachePath_IMG] copy];
        [KFNetwork createDirectory:_KFImageCacheDirectory];
  //      KFLogDebug(@"ImageCache = %@",_KFImageCacheDirectory);
        
	}
    
	return _KFImageCacheDirectory;
}



static inline NSString *KFURLCacheDirectory() {
	if(!_KFURLCacheDirectory) {
        
        
		_KFURLCacheDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:KFNetworkCachaPath_URL] copy];
         [KFNetwork createDirectory:_KFURLCacheDirectory];
	}
    
	return _KFURLCacheDirectory;
}
@implementation KFNetwork
@synthesize requestCount = _requestCount;
@synthesize temQueue = _temQueue;
@synthesize queue = _queue;
@synthesize maxOperationCount = _maxOperationCount;
@synthesize timeOut = _timeOut;
@synthesize supportCompressedData = _supportCompressedData;
@synthesize encoding = _encoding;
@synthesize shouldRespectCacheControl = _shouldRespectCacheControl;
@synthesize defaultImageDownLoadCache = _defaultImageDowLoadCache;
@synthesize defaultUrlDownloadCache = _defaultUrlDownloadCache;
@synthesize jhornLock = _jhornLock;
@synthesize codesinger = _codesinger;

SYNTHESIZE_SINGLETON_FOR_CLASS(KFNetwork)


+(BOOL)createDirectory:(NSString*)path {
    if (nil == path || 0 == [path length]) {
        return NO;
    }
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
       // KFLog(@"Already exist: %@", path);
        return YES;
    }
    else {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
       //     KFLog(@"Fail to create %@, because of: %@", path, [error description]);
            return NO;
        }
        else {
      //      KFLog(@"Succeed to create %@", path);
            return YES;
        }
    }
}


-(id)init{
    if(self = [super init]) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(reachabilityChanged:)
//                                                     name: kReachabilityChangedNotification
//                                                   object: nil];
//        
//        hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
//        [self updateStatus];
//        [hostReach startNotifier];
        
        self.jhornLock = [[[NSRecursiveLock alloc] init] autorelease];
        
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
        
        _supportCompressedData = YES;
        _encoding = NSUTF8StringEncoding;
        
        self.defaultUrlDownloadCache = [[KFUrlDownloadCache alloc] init];
        self.defaultImageDownLoadCache = [[KFImageDownloadCache alloc] init];
        
        @try {
            [self.defaultUrlDownloadCache setStoragePath:KFURLCacheDirectory()];
        }
        @catch (NSException *exception) {
            KFLog(@"%@",exception);
        }
        @finally {
            
        }
        
        @try {
            [self.defaultImageDownLoadCache setStoragePath:KFImageCacheDirectory()];
        }
        @catch (NSException *exception) {
            KFLog(@"%@",exception);
        }
        @finally {
            
        }
//
        
        self.codesinger = [KFRequestCodeSigner sharedInstance];
        
        [self setShouldRespectCacheControl:NO];
    }
    
    return self;
}

-(void)setShouldRespectCacheControl:(BOOL)bflag {
    _shouldRespectCacheControl = bflag;
    [[self defaultImageDownLoadCache] setShouldRespectCacheControlHeaders:bflag];
    [[self defaultUrlDownloadCache] setShouldRespectCacheControlHeaders:bflag];
    [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:bflag];
}

-(void)setMaxOperationCount:(NSInteger)maxOperationCount {
     self.queue.maxConcurrentOperationCount = _maxOperationCount = maxOperationCount;
}

-(void)addPostBobyValus:(ASIFormDataRequest *)formRequest
           postValueDic:(NSDictionary *)postValues {
    if(formRequest && [formRequest isKindOfClass:[ASIFormDataRequest class]] && postValues) {
        NSEnumerator *keyEnum = [postValues keyEnumerator];
        id key;
        id obj;
        while ((key = [keyEnum nextObject]))
        {
            obj = [postValues objectForKey:key];
            [formRequest setPostValue:obj forKey:key];
        }
    }
}

-(void)addPostBobyData:(ASIFormDataRequest *)formRequest postdataArray:(NSArray *)postdataArray
{
    if(formRequest && [formRequest isKindOfClass:[ASIFormDataRequest class]] && postdataArray) {
        
        for(int i = 0; i < [postdataArray count]; i++) {
            NSDictionary *d = [postdataArray objectAtIndex:i];
            [formRequest addData:[d objectForKey:POST_BOBY_DATA_DATA]
                    withFileName:[d objectForKey:POST_BOBY_DATA_FILE_NAME]
                  andContentType:[d objectForKey:POST_BOBY_DATA_CONTENT_TYPE]
                          forKey:[d objectForKey:POST_BOBY_DATA_KEY]];
        }
    }
}


-(void)addPostData:(KFRequestParameter*)param req:(ASIFormDataRequest *)formRequest {
    if(param.postValues) {
        [self addPostBobyValus:formRequest
                  postValueDic:param.postValues];
    }
    
    if(param.postDataList) {
        [self addPostBobyData:formRequest
                  postdataArray:param.postDataList];
    }
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

-(id)requestForParam:(KFRequestParameter*)param {
    
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

-(void)startReqForParam:(KFRequestParameter*)param {
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

-(void)startReqForParam:(KFRequestParameter *)param
              succBlock:(void(^)(id data))succcall
            failedBlock:(void(^)(id data))failcall {

    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    ASIHTTPRequest *request = [self requestForParam:param];
    [request setDidFinishSelector:nil];
    [request setDidFailSelector:nil];

    [request setFailedBlock:^{
        NSDictionary *serrno = [NSDictionary dictionaryWithObjectsAndKeys:[self errorMsg:request.error.code],@"errorMessage",nil];
        
        NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                             code:request.error.code
                                         userInfo:serrno];
        
        failcall(error);
    }];
    
    [request setCompletionBlock:^{
        
        
                NSString *returnType = [request.userInfo objectForKey:RETURN_DATA_TYPE_KEY];
                // NSNumber *reqId = [request.userInfo objectForKey:REQID_KEY];
                NSDictionary* userinfo = request.userInfo;
                KFRequestParameter* param = nil;
                if(userinfo) {
                    param = [userinfo objectForKey:REQ_Param];
                }
                
                if([request didUseCachedResponse] )
                {
                    param.isFromCache = YES;
                    KFLog(@"frame cache");
                }
                
                if([param.method isEqualToString:@"DOWN"]) {
                    
                    NSString* string = request.downloadDestinationPath;
                    if(string) {
                        KFLog(@"down = %@",string);
                        succcall(string);
                    }else {
                        
                        NSDictionary* dict = [NSDictionary dictionaryWithObject:@"request image failed..." forKey:@"errorMessage"];
                        NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                                             code:10003
                                                         userInfo:dict];
                        
                        failcall(error);
                    }
                    return;
                }
                
                BOOL compressed = [request isResponseCompressed];
                if(compressed) {
                    KFLog(@"Data was compressed!");
                }
                
                if([returnType isEqualToString:@"JSON"])
                {
                    [self toJson:request
                            parm:param
                       succBlock:succcall
                     failedBlock:failcall];
                    
                    
                }
                else if([returnType isEqualToString:@"DATA"] ||
                        [returnType isEqualToString:@"DICT"])
                {
                    [self toDictOrData:request
                                  parm:param
                               retType:returnType
                             succBlock:succcall
                           failedBlock:failcall];
                }
        
        
    }];/* block end  */
    
    if(request) {
        //NSDictionary* userinfo = request.userInfo;
        [self.queue addOperation:request];
        [self.temQueue removeObject:request];
    }
}


-(void)setSuspended:(BOOL)b {
    [self.queue setSuspended:b];
}


-(BOOL)isSuppended {
    return [self.queue isSuspended];
}

-(void)cancelAll
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
        [request clearDelegatesAndCancel];
    }
}

-(void)cancelForReqParam:(KFRequestParameter*)param
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
            break;
        }
    }
}

-(void)cancelForReqId:(int64_t)reqId
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
        if([[userInfo objectForKey:REQID_KEY] longLongValue] == reqId)
        {
            [request clearDelegatesAndCancel];
            break;
        }
    }
}



-(void)clearUrlCahce {
    [ASIHTTPRequest clearSession];
    [[ASIDownloadCache
      sharedCache]
     clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [[ASIDownloadCache
      sharedCache]
     clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
    [self.defaultUrlDownloadCache
     clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.defaultUrlDownloadCache
     clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
}

-(void)clearImageDownCache {
    [self.defaultImageDownLoadCache
     clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.defaultImageDownLoadCache
     clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
}


-(void)addRequest:(KFRequestParameter*)paramReq
         delegate:(id<KFNetworkDelegate>) delegate {

    if(self.queue == nil || !paramReq || !paramReq.url) {
        paramReq.requestID = -1;
        return;
    }
    
    
   // NSCondition *mylock = [[NSCondition alloc] init];
    [self.jhornLock lock];
    {
        
        if(nil == paramReq.method || ![paramReq.method isKindOfClass:[NSString class]])
        {
            paramReq.method = @"GET";
        }
        
        if(nil == paramReq.dataFormat || ![paramReq.dataFormat isKindOfClass:[NSString class]])
        {
            paramReq.dataFormat = @"DICT";
        }
        
        ASIFormDataRequest *request = nil;
        NSString *supperMethod = [paramReq.method uppercaseString];
        
        NSString* aUrl = paramReq.url;// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if(![supperMethod isEqualToString:@"DOWN"]) {
            if(![[KFRequestConfig sharedInstance] tokenToCookie]){
                if([KFRequestConfig sharedInstance].token) {
                    aUrl = [aUrl stringByAppendingFormat:@"&%@",[KFRequestConfig sharedInstance].token];
                }
            }
        }
        
        if(paramReq.autoEncodingUrl) {
            aUrl = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSURL *requestURL = [NSURL URLWithString:aUrl];
        if([supperMethod isEqualToString:@"POST"] ) {
            
            if((paramReq.needRequestCodeSign)&&
               [self.codesinger respondsToSelector:
                    @selector(requestCodeSignForParamerter:withToken:postData:)])
            {
                
                NSString* atoken = nil;
                if([self.codesinger respondsToSelector:@selector(productToken)]) {
                    atoken = [self.codesinger productToken];
                }
                
                NSString* codesign =  [self.codesinger requestCodeSignForParamerter:nil
                                                                          withToken:atoken
                                                                           postData:paramReq.postValues];
                NSURL *url = [NSURL URLWithString:aUrl];
                NSString *query = [url query];
                if (query)
                    aUrl = [aUrl stringByAppendingFormat:@"&sysSign=%@",codesign];
                else
                    aUrl = [aUrl stringByAppendingFormat:@"?sysSign=%@",codesign];
                requestURL = [NSURL URLWithString:aUrl];
            }

            
            request = [ASIFormDataRequest requestWithURL:requestURL];
            [self addPostData:paramReq
                          req:request];
            
        } else if([supperMethod isEqualToString:@"DOWN"]) {
            
          //  pol =ASIOnlyLoadIfNotCachedCachePolicy;
            request = [ASIHTTPRequest requestWithURL:requestURL];
            [request setDownloadCache:self.defaultImageDownLoadCache];
            [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setDownloadDestinationPath:[self.defaultImageDownLoadCache pathToStoreCachedResponseDataForRequest:request]];
            //[request setRequestHeaders:[[KFRequestConfig sharedInstance]httpHeaderData]];
            
        }else if([supperMethod isEqualToString:@"GET"]) {
            
            if(paramReq.needRequestCodeSign) {
                NSArray* arrs = [aUrl componentsSeparatedByString:@"?"];
                if(arrs && arrs.count > 1) {
                    NSString* subparm = [arrs objectAtIndex:1];
                    if([self.codesinger respondsToSelector:@selector(requestCodeSignForParamerter:withToken:postData:
                                                                     )]) {
                        
                        NSString* atoken = nil;
                        if([self.codesinger respondsToSelector:@selector(productToken)]) {
                            atoken = [self.codesinger productToken];
                        }
                        
                    
                      NSString* codesign =  [self.codesinger requestCodeSignForParamerter:subparm
                                                            withToken:atoken
                                                             postData:nil];
                        NSURL *url = [NSURL URLWithString:aUrl];
                        NSString *query = [url query];
                        if (query)
                            aUrl = [aUrl stringByAppendingFormat:@"&sysSign=%@",codesign];
                        else
                            aUrl = [aUrl stringByAppendingFormat:@"?sysSign=%@",codesign];
                        requestURL = [NSURL URLWithString:aUrl];
                    }
                    
                }
            }
            
           
            request = [ASIHTTPRequest requestWithURL:requestURL];
            ASICachePolicy pol = ASIUseDefaultCachePolicy;
            if(paramReq.cachePolicy == NetWorkUesCachePolicyAndFailBackToLoadCacheData) {
                pol = ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy;
                [request setSecondsToCache:paramReq.secondsToCache];
                [request setDownloadCache:self.defaultUrlDownloadCache];
            }else if(paramReq.cachePolicy == NetWorkRequestDontUseCachePolicy) {
                pol = ASIDoNotReadFromCacheCachePolicy | ASIDoNotWriteToCacheCachePolicy;
            }else if(paramReq.cachePolicy == NetWorkUesCachePolicy) {
                pol = ASIUseDefaultCachePolicy;
                [request setDownloadCache:self.defaultUrlDownloadCache];
                [request setSecondsToCache:paramReq.secondsToCache];
            }else if(paramReq.cachePolicy == NetWorkOnlyLoadDataFromCachePolicy) {
                pol = ASIOnlyLoadIfNotCachedCachePolicy;
                [request setDownloadCache:self.defaultUrlDownloadCache];
            }else if(paramReq.cachePolicy == NetWorCacheForSessionDurationPolicy) {
                pol = ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy;
                [request setSecondsToCache:paramReq.secondsToCache];
                [request setDownloadCache:self.defaultUrlDownloadCache];
            }
            
  
            [request setCachePolicy:pol];//ASIFallbackToCacheIfLoadFailsCachePolicy|ASIAskServerIfModifiedWhenStaleCachePolicy];
            
#warning 采用这种策略 需要支持缓存清除
            if(paramReq.cachePolicy == NetWorCacheForSessionDurationPolicy) {
                [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
            }else {
                [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            }
        }
        
        if([[KFRequestConfig sharedInstance] tokenToCookie]) {
            [request setRequestCookies:KFNetReqCookies];
        }
        
        [request setAllowCompressedResponse:self.supportCompressedData];
        
        NSMutableDictionary* header = [[KFRequestConfig sharedInstance] httpHeaderData];
        if(header) {
            NSArray * allkeys = [header allKeys];
            for(NSString* key in allkeys) {
                [request addRequestHeader:key value:[header objectForKey:key]];
            }
        }
        
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        request.userInfo = d;
        [d release];
        
        [d setValue:delegate forKey:DELEGATE_KEY];
        [d setValue:paramReq forKey:REQ_Param];
        
        int64_t requestId = self.requestCount ++ ;
        paramReq.requestID = requestId;
        [d setValue:[NSNumber numberWithUnsignedInt:requestId] forKey:REQID_KEY];
        [d setValue:paramReq.dataFormat forKey:RETURN_DATA_TYPE_KEY];
        [request setTimeOutSeconds:self.timeOut];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(successCallBack:)];
        [request setDidFailSelector:@selector(failureCallBack:)];
        [request setQueuePriority:paramReq.requestPriority];
        [self.temQueue addObject:request];
        
    }
    [self.jhornLock unlock];
 //   [mylock release];
}


-(id)getJson:(id)data  {
    
    NSString* responseJSON = nil;
    //if(self.encoding != NSUTF8StringEncoding)
    {
        responseJSON = [[[NSString alloc] initWithData:data
                                              encoding:self.encoding] autorelease];
    }
    return responseJSON;
}


-(void)toJson:(ASIHTTPRequest*)request
         parm:(KFRequestParameter*)param
    succBlock:(void(^)(id data))succcall
  failedBlock:(void(^)(id data))failcall   {

    BOOL compressed = [request isResponseCompressed];
    id responseJSON = nil;
    if(compressed) {
        responseJSON = [self getJson:request.responseData];
    }else {
        responseJSON = [request responseString];
    }
    
    if(responseJSON == nil) {
            
        NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack，response data was NULL" forKey:@"errorMessage" ];
        NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                             code:10001
                                         userInfo:dict];
        failcall(error);

        return;
    }

    if([request didUseCachedResponse]) {
        KFLog(@"**[Respons data from Cache]**");
        [param description];
        
        NSString* path = [[ASIDownloadCache
                           sharedCache]
                          pathToStoreCachedResponseDataForRequest:request];
        KFLog(@"Cache path = %@",path);
    }
    
    succcall(responseJSON);

}

-(void)toJson:(ASIHTTPRequest*)request del:(id)del parm:(KFRequestParameter*)param {

    BOOL compressed = [request isResponseCompressed];
    id responseJSON = nil;
    if(compressed) {
       responseJSON = [self getJson:request.responseData];
    }else {
        responseJSON = [request responseString];
    }
    
    if(responseJSON == nil) {
        if ([del respondsToSelector:@selector(networkDidFailed:
                                              requestParam:error:)]) {
            
            NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack，response data was NULL" forKey:@"errorMessage" ];
            NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                                 code:10001
                                             userInfo:dict];
            
            
            //[del networkDidFailed:self requestParam:param error:error];
            // Added by liangqiaozhong: 由于将ASI的回调放到了子线程，所以，在数据解析之后，通知UI的更新操作需要放到主线程
            [del performSelectorOnMainThread:@selector(networkDidFailed:requestParam:error:) withObject:self withObject:param withObject:error waitUntilDone:NO];
        }
        return;
    }
    
    if ([del respondsToSelector:@selector(networkDidFinished:
                                          requestParam:
                                          data:)]) {
        
        if([request didUseCachedResponse]) {
            KFLog(@"**[Respons data from Cache]**");
            [param description];
            
            NSString* path = [[ASIDownloadCache
                               sharedCache]
                              pathToStoreCachedResponseDataForRequest:request];
            KFLog(@"Cache path = %@",path);
        }
        //[del networkDidFinished:self requestParam:param data:responseJSON];
        // Added by liangqiaozhong: 由于将ASI的回调放到了子线程，所以，在数据解析之后，通知UI的更新操作需要放到主线程
        [del performSelectorOnMainThread:@selector(networkDidFinished:requestParam:data:) withObject:self withObject:param withObject:responseJSON waitUntilDone:NO];
        return;
    }
}


-(void)handleError:(ASIHTTPRequest*)request
              dele:(id)del
               par:(KFRequestParameter*)param
               err:(NSError*)error {

    if ([del respondsToSelector:@selector(networkDidFailed:
                                          requestParam:error:)]) {
        
        //[del networkDidFailed:self requestParam:param error:error];
        // Added by liangqiaozhong: 由于将ASI的回调放到了子线程，所以，在数据解析之后，通知UI的更新操作需要放到主线程
        [del performSelectorOnMainThread:@selector(networkDidFailed:requestParam:error:) withObject:self withObject:param withObject:error waitUntilDone:NO];
    }
}


-(void)toDictOrData:(ASIHTTPRequest*)request
               parm:(KFRequestParameter*)param
            retType:(NSString*)returnType
          succBlock:(void(^)(id data))succcall
        failedBlock:(void(^)(id data))failcall


{
    NSData* data = [request responseData];
    if(data == nil) {
        
        NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack, dataType:data，response data was NULL" forKey:@"errorMessage" ];
        NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                             code:10001
                                         userInfo:dict];
        
        failcall(error);
        return;
    }
    
    id da = data;
    
    if([returnType isEqualToString:@"DICT"])
        
    {
        JSONDecoder* dc = [JSONDecoder decoder];
        NSError* err = nil;
        da =  [dc objectWithData:da
                           error:&err];
        
        if(err != nil)
        {
            
            NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack, DICT，json parse Error Not a JSON" forKey:@"errorMessage" ];
            KFLog(@"successCallBack, DICT，json parse Error Not a JSON");
            
            NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                                 code:10002
                                             userInfo:dict];
            
            failcall(error);
            
            return;
        }
        
    }
    
    if([request didUseCachedResponse]) {
        KFLog(@"**[Respons data from Cache]**");
        [param description];
        
        NSString* path = [[ASIDownloadCache
                           sharedCache]
                          pathToStoreCachedResponseDataForRequest:request];
        KFLog(@"Cache path = %@",path);
    }
    
    
    succcall(da);
    return;
}



-(void)toDictOrData:(ASIHTTPRequest*)request
                del:(id)del
               parm:(KFRequestParameter*)param
            retType:(NSString*)returnType
{
    
    
    NSData* data = [request responseData];
    if(data == nil) {
        
        NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack, dataType:data，response data was NULL" forKey:@"errorMessage" ];
        NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                             code:10001
                                         userInfo:dict];
        
        [self handleError:request
                     dele:del
                      par:param
                      err:error];
        return;
    }
    
    
    
    id da = data;
    
    if([returnType isEqualToString:@"DICT"])
        
    {
        JSONDecoder* dc = [JSONDecoder decoder];
        NSError* err = nil;
        da =  [dc objectWithData:da
                           error:&err];
        
        if(err != nil)
        {
            
            NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack, DICT，json parse Error Not a JSON" forKey:@"errorMessage" ];
            KFLog(@"successCallBack, DICT，json parse Error Not a JSON");
            
            NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                                 code:10002
                                             userInfo:dict];
            
            [self handleError:request
                         dele:del
                          par:param
                          err:error];
            
            return;
        }
        
    }
    
    if([request didUseCachedResponse]) {
        KFLog(@"**[Respons data from Cache]**");
        [param description];
        
        NSString* path = [[ASIDownloadCache
                           sharedCache]
                          pathToStoreCachedResponseDataForRequest:request];
        KFLog(@"Cache path = %@",path);
    }
    
    if ([del respondsToSelector:@selector(networkDidFinished:
                                          requestParam:data:)])
    {
        //[del networkDidFinished:self requestParam:param data:da];
        // Added by liangqiaozhong: 由于将ASI的回调放到了子线程，所以，在数据解析之后，通知UI的更新操作需要放到主线程
        [del performSelectorOnMainThread:@selector(networkDidFinished:requestParam:data:) withObject:self withObject:param withObject:da waitUntilDone:NO];
    }
    return;
}

- (void)successCallBack:(id)sender
{
    ASIHTTPRequest *request = (ASIHTTPRequest *)sender;
    id del = nil;
    //    int iState = [request responseStatusCode];
    if(!request ||
       !request.userInfo ||
       !(del = [request.userInfo objectForKey:DELEGATE_KEY])) {
        return;
    }
    
    
    NSString *returnType = [request.userInfo objectForKey:RETURN_DATA_TYPE_KEY];
    // NSNumber *reqId = [request.userInfo objectForKey:REQID_KEY];
    NSDictionary* userinfo = request.userInfo;
    KFRequestParameter* param = nil;
    if(userinfo) {
        param = [userinfo objectForKey:REQ_Param];
    }
    
    if([request didUseCachedResponse] )
    {
        param.isFromCache = YES;
        KFLog(@"frame cache");
    }
    
    if([param.method isEqualToString:@"DOWN"]) {
        
        if ([del respondsToSelector:@selector(networkDidFinished:
                                              requestParam:
                                              data:)]) {
           
            NSString* string = request.downloadDestinationPath;
            KFLog(@"down = %@",string);
            //[del networkDidFinished:self requestParam:param data:string];
            // Added by liangqiaozhong: 由于将ASI的回调放到了子线程，所以，在数据解析之后，通知UI的更新操作需要放到主线程
            [del performSelectorOnMainThread:@selector(networkDidFinished:requestParam:data:) withObject:self withObject:param withObject:string waitUntilDone:NO];
        }
        return;
    }
    
    BOOL compressed = [request isResponseCompressed];
    if(compressed) {
        KFLog(@"Data was compressed!");
    }

    if([returnType isEqualToString:@"JSON"])
    {
        [self toJson:request
                 del:del
                parm:param];
    }
    else if([returnType isEqualToString:@"DATA"] ||
            [returnType isEqualToString:@"DICT"])
    {
  
        [self toDictOrData:request
                       del:del
                      parm:param
                   retType:returnType];
    }
}


- (NSString *)errorMsg:(NSInteger)error
{
    NSString *msgTip = nil;
    switch (error) {
        case ASIConnectionFailureErrorType:
            msgTip = @"网络链接不上";
            break;
        case ASIRequestTimedOutErrorType:
            msgTip = @"网络链接超时";
            break;
        case ASIAuthenticationErrorType:
            msgTip = @"链接认证失败";
            break;
        case ASIRequestCancelledErrorType:
            msgTip = @"请求已经被取消";
            break;
        case ASIUnableToCreateRequestErrorType:
            msgTip = @"系统生成请求数据失败";
            break;
        case ASITooMuchRedirectionErrorType:
            msgTip = @"链接存在太多的重定向";
            break;
        case ASIUnhandledExceptionError:
            msgTip = @"未知错误";
            break;
        case ASICompressionError:
            msgTip = @"链接时数据压缩失败";
            break;
        default:
            break;
    }
    return msgTip;
    
}


- (void)failureCallBack:(id)sender
{
    ASIHTTPRequest *request = (ASIHTTPRequest *)sender;
    NSDictionary* userinfo = request.userInfo;
    if(userinfo == nil) {
        return;
    }
    
    KFRequestParameter* param = [userinfo objectForKey:REQ_Param];
    id del = nil;
    if(request && request.userInfo && (del = [request.userInfo objectForKey:DELEGATE_KEY]))
    {
       /// NSNumber *reqId = [request.userInfo objectForKey:REQID_KEY];
        NSDictionary *serrno = [NSDictionary dictionaryWithObjectsAndKeys:[self errorMsg:request.error.code],@"errorMessage",nil];
        
        NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                             code:request.error.code
                                         userInfo:serrno];
        
        [self handleError:request
                     dele:del
                      par:param
                      err:error];

    }
}


-(void) dealloc{
    self.queue = nil;
    self.temQueue = nil;
    [super dealloc];
}
@end
