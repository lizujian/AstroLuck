//
//  IDataProvider.m
//  Zhidao
//
//  Created by liangqiaozhong on 13-1-11.
//  Copyright (c) 2013年 Baidu.com. All rights reserved.
//

#import "IDataProvider.h"
#import "IManagerBase.h"
#import "Koala.h"
//#import "CommonDefines.h"
#import "IDataParser.h"
#import "IDataModel.h"

//#import "BTEngine.h"
#import "JSONKit.h"

//#import "TravelException.h"
//#import "NSString+NSString_Ex_.h"
//#import "DownloadTaskSceneAreaOffline.h"
//#import "AlbumDBOperator.h"


#import "KFNetwork+request.h"

//#import "LVHotelDataModel.h"
//#import "BaiduTravelAppDelegate.h"


//#define USE_SIMULATION_DATA


#define kMaxMapRequestId2Delegate 1000

#pragma mark -
#pragma mark Url cache policy
@interface IUrlCache : KFUrlDownloadCache 
// Looks at the request's cache policy and any cached headers to determine if the cache data is still valid
- (BOOL)canUseCachedDataForRequest:(ASIHTTPRequest *)request;

-(void)setStoragePath:(NSString *)sp;

@end
@implementation IUrlCache
// Looks at the request's cache policy and any cached headers to determine if the cache data is still valid
- (BOOL)canUseCachedDataForRequest:(ASIHTTPRequest *)request
{
    BOOL canUseCachedData = [super canUseCachedDataForRequest:request];
    //KFLog(@"url %@, use cached data %d",[[request url] absoluteString],canUseCachedData);
    return canUseCachedData;
}

-(void)setStoragePath:(NSString *)sp
{
    [super setStoragePath:sp];
}

@end

#pragma mark -
#pragma mark 内部接口定义
// 单例模式类别
SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(IDataProvider)

@interface IDataProvider() 
{
      NSMutableDictionary *_mapRequestId2Delegate;
}


// 映射requestId到IManageDelegate
-(void) mapRequestId2Delegate:(KFRequestParameter *)requestParam
                     delegate:(id<IManagerDelegate>)delegate;

// 删除requestId到IManageDelegate的映射
-(void) removeRequestId2Delegate:(int64_t)requestId;

// 根据requestId获取IManagerDelegate
-(id<IManagerDelegate>) getDelegateFromRequestId:(int64_t)requestId;

// 判断uri对应的本地文件缓存是否存在
-(BOOL) isExistCacheInLocalFile:(NSString *)dataURI;

// 获取uri对应的本地文件缓存
-(NSData*) cacheDataInLocalFile:(NSString *)dataURI;

// 向服务器发起网络请求（传入缓存策略），建立IManagerDelegate和requestId的映射关系
-(id) sendRequest2ServerWithCachePolicy:(NSString *)url
                               delegate:(id<IManagerDelegate>)delegate
                        withCachePolicy:(KFRequestCachePolicy)cachePolicy
                           postDataList:(NSArray*)postDataList
                          postDataValue:(NSDictionary*)postDataValue
                          withUserInfo:(NSDictionary *)requestUserInfo;

// 成功获取网络响应时的处理
-(void)networkDidFinished:(KFNetwork*)aNetwork
             requestParam:(KFRequestParameter*)param
                     data:(id)data;

// 网络响应失败时的处理
-(void)networkDidFailed:(KFNetwork*)aNetwork
           requestParam:(KFRequestParameter*)param
                  error:(NSError*)error;

@end

@implementation IDataProvider

// 单例模式实现
SYNTHESIZE_SINGLETON_FOR_CLASS(IDataProvider)

#pragma mark -
#pragma mark 对象初始化
-(id) init
{
    self = [super init];
    if ( nil == self )
        return self;
    
    // 在此进行初始化定义
    _mapRequestId2Delegate = [[NSMutableDictionary alloc] initWithCapacity:kMaxMapRequestId2Delegate];
    
    NSString *storageCachePath = [[KFNetwork sharedInstance].defaultUrlDownloadCache storagePath];
    
    [KFNetwork sharedInstance].defaultUrlDownloadCache = [ [[IUrlCache alloc] init] autorelease];
    [[KFNetwork sharedInstance].defaultUrlDownloadCache setStoragePath:storageCachePath];
    
    return self;
}

-(void) dealloc
{
    [_mapRequestId2Delegate removeAllObjects];
    kSafeRelease(_mapRequestId2Delegate)

    [super dealloc];
}

#pragma mark -
#pragma mark Network相关操作方法

// 向服务器发起网络请求（传入缓存策略），建立IManagerDelegate和requestId的映射关系
-(id) sendRequest2ServerWithCachePolicy:(NSString *)url
                               delegate:(id<IManagerDelegate>)delegate
                        withCachePolicy:(KFRequestCachePolicy)cachePolicy
                           postDataList:(NSArray*)postDataList
                          postDataValue:(NSDictionary*)postDataValue
                          withUserInfo:(NSDictionary *)requestUserInfo

{
    // 发起网络请求
    KFRequestParameter *param = [KFRequestParameter requestParamWithURL:url];
    param.postValues = postDataValue;
    if ( !param ) 
        return nil;
    param.cachePolicy = cachePolicy;
    param.userInfo = requestUserInfo;
    [KFNetwork sharedInstance].supportCompressedData = YES;

    [[KFNetwork sharedInstance] addRequest:param
                                  delegate:(id<KFNetworkDelegate>)self];
    [[KFNetwork sharedInstance] startReqForParam:param];
    
    // 映射requestId到IManageDelegate
    if (delegate != nil) {
        [self mapRequestId2Delegate:param
                           delegate:delegate];
    }
    
    // 返回param
    return [[param retain] autorelease];
}


// 映射requestId到IManageDelegate
-(void) mapRequestId2Delegate:(KFRequestParameter *)requestParam
                     delegate:(id<IManagerDelegate>)delegate
{
    if ( nil == _mapRequestId2Delegate )
        return;
    
    //chenwh %ld -> %lld
    [_mapRequestId2Delegate safeSetObject:delegate
                                   forKey:[NSString stringWithFormat:@"%lld",requestParam.requestID]];
}


// 删除requestId到IManageDelegate的映射
-(void) removeRequestId2Delegate:(int64_t)requestId
{
    if ( nil == _mapRequestId2Delegate )
        return;
    
    //chenwh %ld -> %lld
    [_mapRequestId2Delegate removeObjectForKey:[NSString stringWithFormat:@"%lld",requestId]];
}

// 根据requestId获取IManagerDelegate
-(id<IManagerDelegate>) getDelegateFromRequestId:(int64_t)requestId
{   
    if ( nil == _mapRequestId2Delegate )
        return nil;
    
    //chenwh %ld -> %lld
    NSString *stringKey = [NSString stringWithFormat:@"%lld",requestId];
    if ( !stringKey ) return nil;
    id<IManagerDelegate> delegate = (id<IManagerDelegate>)[_mapRequestId2Delegate objectForKey:stringKey
                                                                              withDefaultValue:nil];
    return delegate;
}

// 成功获取网络响应时的处理
-(void)networkDidFinished:(KFNetwork*)aNetwork
             requestParam:(KFRequestParameter*)param
                     data:(id)data
{
    // 输入参数判断
    if ( nil == aNetwork || nil == param || nil == data )
        return;
    
    KFLog(@"success data %@",data);
    // 根据requestId获取IManagerDelegate
    id<IManagerDelegate> delegate = [self getDelegateFromRequestId:param.requestID];
    if ( nil == delegate )
        return;
    
    // 解析数据模型
    IDataModel *dataModel = [[IDataParser sharedInstance] parseDataFromJSON:data
                                                           withRequestParam:param];
    if ( nil == dataModel )
    {
        // 数据获取失败，调用IManagerDelegate更新UI
        if ( delegate && [delegate respondsToSelector:@selector(updateViewForError:withRequestId:)] )
        {
            [delegate updateViewForError:[[[NSError alloc] init] autorelease]
                           withRequestId:param.requestID];
        }
        else if ( delegate && [delegate respondsToSelector:@selector(updateViewForError:withRequestParam:)] )
        {
            [delegate updateViewForError:[[[NSError alloc] init] autorelease]
                        withRequestParam:param];
        }
        return;
    }
    
//    // 根据param的userInfo设置离线包标识isDataFromOfflinePackage
//    NSString *offlineName = [param.userInfo stringValueForKey:@"isDataFromOfflinePackage" defaultValue:nil operation:NSStringOperationTypeTrim];
//    dataModel.isDataFromOfflinePackage = (nil == offlineName)?NO:YES;
//    dataModel.userInfo = param.userInfo;
    
    // 根据param的userInfo设置(dbkey不为空，且不是从数据库中获取的json)写数据库字段将json数据库持久化到本地DB  chenjiedan
//    NSString *loadFromDBCached = [param.userInfo stringValueForKey:@"LoadFromDBJsonCache" defaultValue:nil operation:NSStringOperationTypeTrim];
//    
//    dataModel.jsonValue = [data JSONString];
//    if ([dataModel.jsonValue length] < 4) {
//        dataModel.jsonValue = nil;
//    }
//    if (nil == loadFromDBCached) {
//        dataModel.isDataFromDB = NO;
//        NSString *dbKey = [param.userInfo stringValueForKey:@"DBKey" defaultValue:nil operation:NSStringOperationTypeTrim];
//        if (dbKey != nil && ![dbKey isEqualToString:@""]) {
//            dataModel.dbKey = dbKey;
//            if ([dataModel respondsToSelector:@selector(saveInDB)]) {
//                [dataModel saveInDB];
//            }
//        }
//    }else{
//        dataModel.isDataFromDB = YES;
//    }

   
    // 数据模型解析成功，调用IManagerDelegate更新UI
    
//    NSRange range = [[dataModel description] rangeOfString:@"errno = 0"];
//    BOOL error = NO;
//    if (range.location == NSNotFound) {
//        error = YES;
//    }
    
    if (delegate && [delegate respondsToSelector:@selector(updateViewForSuccess:withRequestId:)] )
    {
        [delegate updateViewForSuccess:dataModel
                         withRequestId:param.requestID];
    }
    else if ( delegate && [delegate respondsToSelector:@selector(updateViewForSuccess:withRequestParam:)] )
    {
        [delegate updateViewForSuccess:dataModel
                      withRequestParam:param];
    }
}

// 网络响应失败时的处理
-(void)networkDidFailed:(KFNetwork*)aNetwork
           requestParam:(KFRequestParameter*)param
                  error:(NSError*)error
{
    // 输入参数判断
    if ( nil == aNetwork || nil == param )
        return;
    
    // 根据requestId获取IManagerDelegate
    id<IManagerDelegate> delegate = [self getDelegateFromRequestId:param.requestID];
    if ( nil == delegate )
        return;
    
    // 网络数据获取失败，调用IManagerDelegate更新UI
    if ( delegate && [delegate respondsToSelector:@selector(updateViewForError:withRequestId:)] )
    {
        [delegate updateViewForError:error
                       withRequestId:param.requestID];
    }
    else if ( delegate && [delegate respondsToSelector:@selector(updateViewForError:withRequestParam:)] )
    {
        [delegate updateViewForError:error
                    withRequestParam:param];
    }
}

#pragma mark -
#pragma mark 数据处理接口

// 判断uri对应的本地文件缓存是否存在
-(BOOL) isExistCacheInLocalFile:(NSString *)dataURI
{
    KFUrlDownloadCache *urlCache = (KFUrlDownloadCache *)[KFNetwork sharedInstance].defaultUrlDownloadCache;
    NSString  *cachePath = [urlCache pathToCachedResponseDataForURL:[NSURL URLWithString:dataURI]];
    return  ( nil != cachePath );
}

// 获取uri对应的本地文件缓存
-(NSData*) cacheDataInLocalFile:(NSString *)dataURI
{
    KFUrlDownloadCache *urlCache = (KFUrlDownloadCache *)[KFNetwork sharedInstance].defaultUrlDownloadCache;
    NSData  *cacheData = [urlCache cachedResponseDataForURL:[NSURL URLWithString:dataURI]];
    return  cacheData;
}

// 获取数据
-(id) syncFetchData:(NSString *)dataURI
{
    return nil;
}

// 异步获取数据，返回请求Id
-(int64_t) asyncFetchData:(NSString *)dataURI
          withCachePolicy:(IDataCachePolicy)cachePolicy
       withDataParseClass:(Class)parseClass
         withDataDelegate:(id<IManagerDelegate>)delegate
{
    return [self asyncFetchDataWithUserInfo:dataURI
                                   userInfo:nil
                            withCachePolicy:cachePolicy
                         withDataParseClass:parseClass
                           withDataDelegate:delegate];
}

// 异步获取数据，返回请求Id（附加以Dictionary方式传递用户参数）
/*userInfo 的格式为一个字典，至少包括以下的数据
 *QueryType:查询的内容类型为枚举型：ERequestType，主要是（RequestTypeSceneDetail，RequestTypeNotesView，RequestTypeNoteData，RequestTypeSceneData
 *SceneId：景点的id
 *ParentSid：景点的父节点的id
 *NoteId：游记的id
 *OfflineName：离线文件的标识
 *TagListTag:tag_list的tag（有该字段，说明还有二级，需要再次解析一个中间文件的tag_list）
 *TagName:tagName
 *IsOffline
 *--------------optional
 *FakeJson 
 *DBKey
 *LoadFromDBJsonCache
 *PostDataValue
 */

- (int64_t)asyncFetchDataWithUserInfo:(NSString *)dataURI
                             userInfo:(NSDictionary *)userInfo
                      withCachePolicy:(IDataCachePolicy)cachePolicy
                   withDataParseClass:(Class)parseClass
                     withDataDelegate:(id<IManagerDelegate>)delegate
{

//#ifdef USE_SIMULATION_DATA    
//    //Add By Chenjiedan For FakeJson Construct
//    NSString *jsonPath = [userInfo objectForKey:@"FakeJson" withDefaultValue:nil];
//    if (jsonPath != nil) {
//        return [self asyncFetchLocalFakeDataWithUserInfo:jsonPath userInfo:userInfo withCachePolicy:cachePolicy withDataParseClass:parseClass withDataDelegate:delegate];
//    }
//#endif
    
#ifdef USE_SIMULATION_DATA
    {
        // 分配KFRequestParameter
        KFRequestParameter *offlineParam = [[KFRequestParameter new]autorelease];
        if (nil == offlineParam)
        {
            return kInvalidRequestId;
        }
        
        // 生成requestid
        offlineParam.requestID = [[KFNetwork sharedInstance]addRequestCount];
        
        // 设置param的userinfo,以便在networkDidFinished里设置数据模型的离线包标识：isDataFromOfflinePackage
        offlineParam.userInfo = userInfo;
        
        // 映射requestId到IManageDelegate
        [self mapRequestId2Delegate:offlineParam delegate:delegate];
        
        // 将请求参数映射到数据模型类，以便网络响应完成后进行数据模型解析
        [[IDataParser sharedInstance] mapRequestParam2DataModelClass:offlineParam andDataModelClass:parseClass];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self networkDidFinished:[KFNetwork sharedInstance] requestParam:offlineParam data:[NSDictionary dictionary]];
        });

        return offlineParam.requestID;
    }
#endif
    
    // 输入参数判断
    if ( nil == dataURI )
        return kInvalidRequestId;
    
    // 根据传入参数设置缓存策略
    KFRequestCachePolicy requestCachePolicy = NetWorkUesCachePolicyAndFailBackToLoadCacheData;
    switch (cachePolicy) {
        case IDataCachePolicyLocalFile:
        {
            requestCachePolicy = NetWorkOnlyLoadDataFromCachePolicy;
            break;
        }
        case IDataCachePolicyLocalFileAndNetwork:
        {
            requestCachePolicy = NetWorkUesCachePolicyAndFailBackToLoadCacheData;
            break;
        }
        case IDataCachePolicyNetwork:
        {
            requestCachePolicy = NetWorkRequestDontUseCachePolicy;
            break;
        }
        case IDataCachePolicyDBCachedJson:
        {
            NSString *dbKey = [userInfo objectForKey:@"DBKey" withDefaultValue:nil];
            //从本地数据库中查找，尝试找到已经存储的json数据。
            NSString *dbJson =  [self jsonInDBForKey:dbKey];
            //判断是否找到json数据
             return   [self fetchLocalCachedJson:dbJson WithUserInfo:userInfo withCachePolicy:IDataCachePolicyDBCachedJson withDataParseClass:parseClass withDataDelegate:delegate];
      
        }
    }
    
    // 发起网络请求
    
    NSDictionary *DIC = [userInfo objectForKey:@"PostDataValue" withDefaultValue:nil];
    
    KFRequestParameter *param = (KFRequestParameter *)
    [self sendRequest2ServerWithCachePolicy:dataURI
                                   delegate:delegate
                            withCachePolicy:requestCachePolicy
                               postDataList:nil
                              postDataValue:DIC
                                   withUserInfo:userInfo];
    
    //如果userInfo中带有DBKey字段，说明需要存储此JSON数据
    NSString *dbKey = [userInfo objectForKey:@"DBKey" withDefaultValue:nil];
    if (nil != dbKey) {
        param.userInfo = userInfo;
    }

    
    if ( nil == param )
        return kInvalidRequestId;
    
    // 将请求参数映射到数据模型类，以便网络响应完成后进行数据模型解析
    if (parseClass != nil) {
        [[IDataParser sharedInstance] mapRequestParam2DataModelClass:param
                                                   andDataModelClass:parseClass];
    }
    
    // 返回请求Id
    return param.requestID;
}

// 异步Post数据，返回请求Id
-(int64_t) asyncPostData:(NSString *)dataURI
              postValues:(NSDictionary *)postVaues
            postDataList:(NSArray *)dataArrays
//         withCachePolicy:(IDataCachePolicy)cachePolicy
                userInfo:(NSDictionary *)userInfo
      withDataParseClass:(Class)parseClass
        withDataDelegate:(id<IManagerDelegate>)delegate
{
    // 输入参数判断
    if ( nil == dataURI ) 
        return kInvalidRequestId;
    
    // 发起网络请求
    KFRequestParameter *param = [KFRequestParameter requestParamWithURL:dataURI
                                                             postValues:postVaues
                                                           postDataList:dataArrays
                                                                 method:@"POST"];
    if ( !param ) 
        return kInvalidRequestId;
    
    //如果userInfo中带有DBKey字段，说明需要存储此JSON数据
    NSString *dbKey = [userInfo objectForKey:@"DBKey" withDefaultValue:nil];
    if (nil != dbKey) {
        param.userInfo = userInfo;
    }

    
    param.cachePolicy = NetWorkRequestDontUseCachePolicy;
    
    [[KFNetwork sharedInstance] addRequest:param delegate:(id<KFNetworkDelegate>)self];
    [[KFNetwork sharedInstance] startReqForParam:param];
    
    // 映射requestId到IManageDelegate
    [self mapRequestId2Delegate:param delegate:(id<IManagerDelegate>)delegate];
    
    // 将请求参数映射到数据模型类，以便网络响应完成后进行数据模型解析
    if (parseClass != nil) {
        [[IDataParser sharedInstance] mapRequestParam2DataModelClass:param
                                                   andDataModelClass:parseClass];
    }
    
    // 返回请求Id
    return param.requestID;

}
// 保存数据
-(BOOL) saveData:(NSString *)dataURI
            data:(id)data
{
    return NO;
}


// 取消数据获取(或数据Post)请求（传入请求Id）
-(void) cancelFetchDataRequestByRequestID:(int64_t)requestId
{
    if ( kInvalidRequestId == requestId )
        return;
    
    [self removeRequestId2Delegate:requestId];
    
    [[KFNetwork sharedInstance] cancelForReqId:requestId];
}

#pragma mark
#pragma mark 用于测试：获取本地假JSON数据

- (int64_t)asyncFetchLocalFakeDataWithUserInfo:(NSString *)jsonPath
                             userInfo:(NSDictionary *)userInfo
                      withCachePolicy:(IDataCachePolicy)cachePolicy
                   withDataParseClass:(Class)parseClass
                     withDataDelegate:(id<IManagerDelegate>)delegate
{
    // 分配KFRequestParameter
    KFRequestParameter *param = [[KFRequestParameter new]autorelease];
    if (nil == param)
    {
        return kInvalidRequestId;
    }
    
    // 生成requestid
    param.requestID = [[KFNetwork sharedInstance]addRequestCount];
    
    // 设置param的userinfo,以便在networkDidFinished里设置数据模型的离线包标识：isDataFromOfflinePackage
    param.userInfo = userInfo;
    
    // 映射requestId到IManageDelegate
    [self mapRequestId2Delegate:param delegate:delegate];
    
    // 将请求参数映射到数据模型类，以便网络响应完成后进行数据模型解析
    [[IDataParser sharedInstance] mapRequestParam2DataModelClass:param andDataModelClass:parseClass];
    
    [self parseLocalJson:jsonPath withRequstParameter:param];
    
    return param.requestID;
}
-(void) parseLocalJson:(NSString*)offlinePath withRequstParameter:(KFRequestParameter*)param
{
    // 根据传入url参数，找到离线json文件，并读取json内容
    NSData *jsonData = nil;
    
    //找到路径了。
    offlinePath = [[NSBundle mainBundle] pathForResource:offlinePath ofType:nil];

    jsonData = [[[NSData alloc]initWithContentsOfFile:offlinePath] autorelease];
    
    // 调用networkDidFinished，并传入json内容和delegate
    if ((nil == jsonData || 0 == jsonData.length))
    {
        //当json文件为空或者没有这个文件，回调失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [self networkDidFailed:[KFNetwork sharedInstance] requestParam:param error:nil];
        });
    }
    else
    {
        JSONDecoder* dc = [JSONDecoder decoder];
        NSError* err = nil;
        id data = nil;
        
        data = [dc objectWithData:jsonData error:&err];

        if(err != nil)
        {
            NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack, DICT，json parse Error Not a JSON" forKey:@"errorMessage" ];
            KFLog(@"successCallBack, DICT，json parse Error Not a JSON");
            
            NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                                 code:10002
                                             userInfo:dict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self networkDidFailed:[KFNetwork sharedInstance] requestParam:param error:error];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self networkDidFinished:[KFNetwork sharedInstance] requestParam:param data:data];
        });
    }
}


#pragma mark
#pragma mark 查找本地DB数据库
-(NSString *)jsonInDBForKey:(NSString *)dbKey
{
    if ([dbKey isEqualToString:@""] || nil == dbKey) {
        return nil;
    }else{
        return nil;
    }
}



-(int64_t) fetchLocalCachedJson:(NSString *)localJson
                   WithUserInfo:(NSDictionary *)userInfo
                withCachePolicy:(IDataCachePolicy)cachePolicy
             withDataParseClass:(Class)parseClass
               withDataDelegate:(id<IManagerDelegate>)delegate
{
    // 分配KFRequestParameter
    KFRequestParameter *offlineParam = [[KFRequestParameter new]autorelease];
    if (nil == offlineParam)
    {
        return kInvalidRequestId;
    }
    
    // 生成requestid
    offlineParam.requestID = [[KFNetwork sharedInstance]addRequestCount];

    // 设置param的userinfo,以便在networkDidFinished里设置数据模型的离线包标识：isDataFromOfflinePackage
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [mutDic setObject:@"YES" forKey:@"LoadFromDBJsonCache"];
    offlineParam.userInfo = mutDic;
    
    // 映射requestId到IManageDelegate
    [self mapRequestId2Delegate:offlineParam delegate:delegate];
    
    // 将请求参数映射到数据模型类，以便网络响应完成后进行数据模型解析
    if (parseClass != nil) {
        [[IDataParser sharedInstance] mapRequestParam2DataModelClass:offlineParam
                                                   andDataModelClass:parseClass];
    }
    // 调用networkDidFinished，并传入json内容和delegate
    if ((nil == localJson || 0 == localJson.length))
    {
        //当json文件为空或者没有这个文件，回调失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [self networkDidFinished:[KFNetwork sharedInstance] requestParam:offlineParam data:[NSDictionary dictionary]];
//            [self networkDidFailed:[KFNetwork sharedInstance] requestParam:offlineParam error:nil];
        });
    }
    else
    {
        JSONDecoder* dc = [JSONDecoder decoder];
        NSError* err = nil;
        id data = nil;
        NSData *jsonData = [localJson dataUsingEncoding:NSUTF8StringEncoding];

       
        data = [dc objectWithData:jsonData error:&err];
       
        
        if(err != nil)
        {
            
            NSDictionary* dict = [NSDictionary dictionaryWithObject:@"successCallBack, DICT，json parse Error Not a JSON" forKey:@"errorMessage" ];
            KFLog(@"successCallBack, DICT，json parse Error Not a JSON");
            
            NSError* error = [NSError errorWithDomain:@"_KFrameWork_Core_network"
                                                 code:10002
                                             userInfo:dict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self networkDidFailed:[KFNetwork sharedInstance] requestParam:offlineParam error:error];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self networkDidFinished:[KFNetwork sharedInstance] requestParam:offlineParam data:data];
        });
    }
    return offlineParam.requestID;
}
@end
