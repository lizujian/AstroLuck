//
//  KFRequestParameter.h
//  KoalaFramework
//
//  Created by JHorn.Han on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _KFRequestCachePolicy {
    
    //不使用缓存策略
    NetWorkRequestDontUseCachePolicy = 0,
    
    
    //使用缓存策略，当请求时，
    //  1>如果有缓存,首先判断是否过期，如果没有过期则使用缓存。如果有过期，请求先进行网络请求，
    //    判断服务器版本与本地版本是否一样，如果一样，则使用缓存。如果服务器有新版本，会进行网络请求，并更新本地缓存
    //  2>如果没有缓存，则直接开始网络请求
    //  3>当出现网络请求异常错误时（例如没有网络），会直接开始读取缓存数据。 （常用）
    NetWorkUesCachePolicyAndFailBackToLoadCacheData = 1,
    
    
    // 与NetWorkUesCachePolicyAndFailBackToLoadCacheData 1，2相同，在网络异常错误时，不会读取本地数据
    NetWorkUesCachePolicy = 2,
    
    // 请求数据不管数据是否过期都从缓存中先读取（只从缓存中请求数据）（不常用）
    NetWorkOnlyLoadDataFromCachePolicy = 3,
    
    
    //如NetWorkUesCachePolicyAndFailBackToLoadCacheData一样，但是对于缓存的数据只在本次有效，如果重新启动
    //缓存将会失效NetWorkUesCachePolicyAndFailBackToLoadCacheData
    NetWorCacheForSessionDurationPolicy = 4,
} KFRequestCachePolicy;


typedef enum _KFRequestPriority_ {

 	KFRequestPriorityVeryLow = -8L,
	KFRequestPriorityLow = -4L,
	KFRequestPriorityNormal = 0,
	KFRequestPriorityHigh = 4,
	KFRequestPriorityVeryHigh = 8

}KFRequestPriority;



@interface KFRequestParameter : NSObject {
    
    // URL
    NSString*       _urlString;
    
    // 默认为YES  如果用户对传入的URL已经做ENCODE的话 怎将 autoEncodingUrl ＝ NO
    BOOL            _autoEncodingUrl;
    
    // Post 发送的数据
    NSDictionary*   _postValues;
    
    // Post 发送的附件 例如 文件，图片
    NSArray*        _postDataList;
    
    // 请求方式
    // GET,POST
    // DOWN,用来请求下载图片，文件可以使用，并且默认支持了对图片，文件的缓存，
    NSString*       _method;
    
    // 数据的返回格式
    // DICT:NSDictionary
    // JSON:JSON字符串
    // DATA:NSDatas数据流
    NSString*       _dataFormat;
    
    //请求后获得的请求ID
    int64_t         _requestID;
    
    
    //请求策略，默认为 NetWorkUesCachePolicyAndFailBackToLoadCacheData
    KFRequestCachePolicy _cachePolicy;
    
    //请求的过期时间
    NSTimeInterval _secondsToCache;
    
    //附带的用户信息
    NSDictionary* _userInfo;
    
    //缓存目录
    NSString* _iamgecacheDirectory;
    
    //
    BOOL _isFromCache;
    
    //优先级
    KFRequestPriority requestPriority;
    
    //是否使用请求签名
    BOOL _needRequestCodeSign;
}

@property(nonatomic,retain) NSDictionary* postValues;
@property(nonatomic,retain) NSArray* postDataList;
@property(nonatomic,copy) NSString* method;
@property(nonatomic,copy) NSString* url;
@property(nonatomic,copy) NSString* dataFormat;
@property(nonatomic,assign) int64_t requestID;
@property(nonatomic,assign)KFRequestCachePolicy cachePolicy;
@property(nonatomic,retain)NSDictionary* userInfo;
@property(nonatomic,assign)NSTimeInterval secondsToCache;
@property(nonatomic,copy) NSString* iamgecacheDirectory;
@property(nonatomic,assign)BOOL isFromCache;
@property(nonatomic,assign)KFRequestPriority requestPriority;
@property(nonatomic,assign)BOOL needRequestCodeSign;
@property(nonatomic,assign)BOOL autoEncodingUrl;

-(id)initWithRequestUrl:(NSString*)aUrl;

-(id)initWithRequestURL:(NSString *)aUrl
      postValues:(NSDictionary*)postValuesDict
    postDataList:(NSArray*)dataList
          method:(NSString*)requestMethod;

+(id)requestParamWithURL:(NSString*)aUrl;

+(id)requestParamWithURL:(NSString *)aUrl
      postValues:(NSDictionary*)postValuesDict
    postDataList:(NSArray*)dataList
          method:(NSString*)requestMethod;

@end
