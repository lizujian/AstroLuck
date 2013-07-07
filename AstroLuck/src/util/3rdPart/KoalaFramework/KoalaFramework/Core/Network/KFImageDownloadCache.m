//
//  KFImageDownloadCache.m
//  KoalaFramework
//
//  Created by JHorn.Han on 10/26/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFImageDownloadCache.h"

@implementation KFImageDownloadCache
-(void)setStoragePath:(NSString *)sp {
    [super setStoragePath:sp];
}

- (NSString *)pathToStoreCachedResponseDataForRequest:(ASIHTTPRequest *)request {

          return  [super pathToStoreCachedResponseDataForRequest:request];

}
@end
