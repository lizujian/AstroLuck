//
//  KFRequestCodeSigner.h
//  KoalaFramework
//
//  Created by JHorn.Han on 11/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "KFRequestCodeSignerDelegate.h"


/*
    如果产品需要对请求做加密签名处理，在请求时候将
    KFRequestParameter needRequestCodeSign ＝ YES；
 
 
     KFNetwork 中的
     id<KFRequestCodeSignerDelegate> _codesinger;
     codesinger 默认为KFRequestCodeSigner，
 
    如果各个产品需要实现加密签名请求，可以继承此类，去重写相应的 productToken 和
    requestCodeSignForParamerter方法,并且确认KFRequestCodeSignerDelegate 协议。

    
 
 */

@interface KFRequestCodeSigner : NSObject <KFRequestCodeSignerDelegate>


/* 
 
    产品的Product Token,
   
    制作加密request url签名需要product token
 
 */
-(NSString*)productToken;


/*
 
    制作签名的方法，默认的制作方法 
 
    ->
     Get/Post 中的 key/value 对都必须经过 urlencode 处理，且必须是 UTF-8 编码
     将所有参数(包含 Get/Post 所有参数，但不包含 sysSign)格式化为“key=value”格式，如“k1=v1”、
     “k2=v2”、“k3=v3”；
     将格式化好的参数键值对以字典序升序排列后，拼接在一起，如“k1=v1k2=v2k3=v3”
     sign=MD5($k1=$v1$k2=$v2$k3=$v3$token);（其中的 kv 都是 urlencode 后的）
 
 */
-(id)requestCodeSignForParamerter:(NSString*)urlpara
                        withToken:(NSString*)prodctToken
                         postData:(NSDictionary*)postdata;


SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KFRequestCodeSigner);




@end
