//
//  IManager+ModuleDayInfo.m
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "IManager+ModuleDayInfo.h"
#import "AstroDayDataModel.h"

@implementation IManager (ModuleDayInfo)

-(int64_t)requestTodayAstro:(NSString *)astroName language:(AstroLanguageType)languageType withDelegate:(id<IManagerDelegate>)delegate
{
    // 异步获取数据
    NSString *urlSuffix = [NSString stringWithFormat:kTodayPrefix,astroName];
    NSString *url = [UtilManager getFormattedUrl:urlSuffix];
    
    KFLog(@"request url %@",url);
    return [[IDataProvider sharedInstance] asyncFetchDataWithUserInfo:url
                                                             userInfo:nil
                                                      withCachePolicy:IDataCachePolicyLocalFileAndNetwork
                                                   withDataParseClass:[AstroToDayDataModel class]
                                                     withDataDelegate:delegate];
}

-(int64_t)requestTomorrowAstro:(NSString *)astroName language:(AstroLanguageType)languageType withDelegate:(id<IManagerDelegate>)delegate
{
    // 异步获取数据
    NSString *urlSuffix = [NSString stringWithFormat:kTomorrowPrefix,astroName];
    NSString *url = [UtilManager getFormattedUrl:urlSuffix];
    
    KFLog(@"request url %@",url);
    return [[IDataProvider sharedInstance] asyncFetchDataWithUserInfo:url
                                                             userInfo:nil
                                                      withCachePolicy:IDataCachePolicyLocalFileAndNetwork
                                                   withDataParseClass:[AstroTomorrowDataModel class]
                                                     withDataDelegate:delegate];
}

@end
