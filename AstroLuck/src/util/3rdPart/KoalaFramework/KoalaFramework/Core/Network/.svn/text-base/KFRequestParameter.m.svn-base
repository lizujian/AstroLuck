//
//  KFRequestParameter.m
//  KoalaFramework
//
//  Created by JHorn.Han on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFRequestParameter.h"
#import "ASIHTTPRequest.h"

@implementation KFRequestParameter
@synthesize postValues = _postValues;
@synthesize postDataList = _postDataList;
@synthesize method = _method;
@synthesize url = _url;
@synthesize dataFormat = _dataFormat;
@synthesize requestID = _requestID;
@synthesize cachePolicy = _cachePolicy;
@synthesize userInfo = _userInfo;
@synthesize secondsToCache = _secondsToCache;
@synthesize iamgecacheDirectory = _iamgecacheDirectory;
@synthesize isFromCache = _isFromCache;
@synthesize needRequestCodeSign = _needRequestCodeSign;
@synthesize requestPriority;
@synthesize autoEncodingUrl = _autoEncodingUrl;
-(id)init {
    if(self = [super init]) {
        self.postDataList = nil;
        self.postValues = nil;
        self.method = @"GET"; 
        self.url = nil;
        self.dataFormat = @"DICT"; //@"DATA" //"JSON"
        self.requestID = -1;
        self.secondsToCache = 0;
        self.cachePolicy = NetWorkUesCachePolicyAndFailBackToLoadCacheData;
        self.isFromCache = NO;
        self.requestPriority = KFRequestPriorityNormal;
        self.needRequestCodeSign = NO;
        self.autoEncodingUrl = YES;
    }
    
    return self;
}

-(NSString *)description {
    
    return [NSString stringWithFormat:@"method=%@,url=%@,dataFormat=%@,requestID=%llu,postValues=%@,postDataList=%@,userInfo=%@",
            self.method,
            self.url,
            self.dataFormat,
            self.requestID,
            self.postValues,
            self.postDataList,
            self.userInfo
            ];
    
}

-(id)initWithRequestUrl:(NSString*)aUrlString {

    if((self = [self init])) {
        self.url = aUrlString;
    }
    return self;
}

+(id)requestParamWithURL:(NSString*)aUrlString {

    return [[[self alloc] initWithRequestUrl:aUrlString] autorelease];
}

-(id)initWithRequestURL:(NSString *)aUrl
      postValues:(NSDictionary*)postValuesDict
    postDataList:(NSArray*)dataList
          method:(NSString*)requestMethod {
    
    if((self = [self init])) {
        self.url = aUrl;
        self.postDataList = dataList;
        self.postValues = postValuesDict;
        self.method = requestMethod;
    }
    
    return self;
    
}


+(id)requestParamWithURL:(NSString *)aUrl
              postValues:(NSDictionary*)postValuesDict
            postDataList:(NSArray*)dataList
                  method:(NSString*)requestMethod {
    
    return [[[self alloc] initWithRequestURL:aUrl
                                 postValues:postValuesDict
                               postDataList:dataList
                                     method:requestMethod] autorelease];
}

-(void)dealloc
{
    self.postValues = nil;
    self.postDataList = nil;
    self.method = nil;
    self.url = nil;
    self.dataFormat = nil;
    self.iamgecacheDirectory = nil;
    self.userInfo = nil;
    [super dealloc];
}
@end
