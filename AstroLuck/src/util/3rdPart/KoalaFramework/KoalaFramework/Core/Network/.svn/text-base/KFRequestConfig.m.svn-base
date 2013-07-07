//
//  KFRequestConfig.m
//  KoalaFramework
//
//  Created by JHorn.Han on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFRequestConfig.h"
#import "KFNetwork.h"

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KFRequestConfig);

@interface KFRequestConfig()
@property(nonatomic,retain)  NSHTTPCookie* cookie;
@end

@implementation KFRequestConfig
@synthesize token = _token;
@synthesize cookie = _cookie;
@synthesize httpHeaderData = _httpHeaderData;
@synthesize tokenToCookie = _tokenToCookie;
SYNTHESIZE_SINGLETON_FOR_CLASS(KFRequestConfig)

-(void)dealloc {
    self.token = nil;
    [super dealloc];
}


- (NSHTTPCookie *)buildCookie
{
    if(self.token)
    {
        NSString* key = nil;
        NSString* bduss = nil;
        NSArray* arrs = [self.token componentsSeparatedByString:@"="];
        if(arrs.count <= 1) {
            key = @"BDUSS";
            bduss = self.token;
        }else{
            key = [arrs objectAtIndex:0];
            bduss = [arrs objectAtIndex:1];
        }
        NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:bduss forKey:NSHTTPCookieValue];
        [properties setValue:key forKey:NSHTTPCookieName];
        [properties setValue:@".baidu.com" forKey:NSHTTPCookieDomain];
        [properties setValue:[NSDate dateWithTimeIntervalSinceNow:3600*24*7] forKey:NSHTTPCookieExpires];
        [properties setValue:@"/" forKey:NSHTTPCookiePath];
        self.cookie = [NSHTTPCookie cookieWithProperties:properties];
        [properties release];
    }
    return _cookie;
}

-(uint64_t)sizeOfURLCache {
    
    NSString* path = nil;
   
    path = [NSHomeDirectory() stringByAppendingPathComponent:KFNetworkCachaPath_URL];
    
   // NSLog(@"BDIMageChaPath = %@",path);
    NSDirectoryEnumerator* e = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    NSString *file = nil;
    
    double totalSize = 0;
    while ((file = [e nextObject]))
    {
        NSDictionary *attributes = [e fileAttributes];
        
        NSNumber *fileSize = [attributes objectForKey:NSFileSize];
        
        totalSize += [fileSize longLongValue];
    }
    
    return totalSize;
    
}


-(uint64_t)sizeOfKFImageCache {
    
    
    NSString* path = nil;
    
    path = [NSHomeDirectory() stringByAppendingPathComponent:KFNetworkCachePath_IMG];
    
    //NSLog(@"BDIMageChaPath = %@",path);
    NSDirectoryEnumerator* e = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    NSString *file = nil;
    
    double totalSize = 0;
    while ((file = [e nextObject]))
    {
        NSDictionary *attributes = [e fileAttributes];
        
        NSNumber *fileSize = [attributes objectForKey:NSFileSize];
        
        totalSize += [fileSize longLongValue];
    }
    return totalSize;
}

-(void)cleanURLCache {
    [[KFNetwork sharedInstance] clearUrlCahce];
}


-(void)cleanImageCache {
    [[KFNetwork sharedInstance] clearImageDownCache];
}



- (NSMutableArray *)cookies
{
    NSHTTPCookie *temptCookie = [self buildCookie];
    if(temptCookie)
    {
        return [NSMutableArray arrayWithObject:temptCookie];
    }
    return nil;
}


@end
