//
//  KFRequestConfig.h
//  KoalaFramework
//
//  Created by JHorn.Han on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"



#define KFNetworkCachaPath_URL @"Library/Caches/.bd_kfurl_"
#define KFNetworkCachePath_IMG @"Library/Caches/.bd_kfImag_"

#define KFNetReqCookies [[KFRequestConfig sharedInstance] cookies]
#define KFNetReqBduss [[KFRequestConfig sharedInstance] token]
@interface KFRequestConfig : NSObject
{
    
    //YES: _token 会放入到HTTP header Cookie中
    //NO: _token 会放入到URL串中 (默认)
    BOOL _tokenToCookie;
    
    
    //e.g. Key＝value， token = @"bduss=12XAxsdIO3245fFFEr4E33320sM33456g" --> @"http://192.168.1.1/?ket=10&bduss=12xsxsd3245fFFEr4(33320s@33456g"
    NSString* _token;
    
    
    //如果tokenToCookie＝YES，cookie数据来源于token,外部获取通过cookies，否则为NULL
    NSHTTPCookie* _cookie;
    
    
    //开发者可自定相应的数据到http Header中。
    NSMutableDictionary* _httpHeaderData;
}

@property(nonatomic,copy) NSString* token;
@property(nonatomic,retain) NSMutableDictionary* httpHeaderData;
@property(nonatomic,assign)BOOL tokenToCookie;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KFRequestConfig);

- (NSMutableArray *)cookies;

-(uint64_t)sizeOfURLCache;
-(uint64_t)sizeOfKFImageCache;
-(void)cleanURLCache;
-(void)cleanImageCache;


@end
