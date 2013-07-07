//
//  KFImageDownloadCache.h
//  KoalaFramework
//
//  Created by JHorn.Han on 10/26/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "ASIDownloadCache.h"

@interface KFImageDownloadCache : ASIDownloadCache

-(void)setStoragePath:(NSString *)sp;
- (NSString *)pathToStoreCachedResponseDataForRequest:(ASIHTTPRequest *)request;
@end
