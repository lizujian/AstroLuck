//
//  UtilManager.m
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "UtilManager.h"

@implementation UtilManager
+(NSString *)getFormattedUrl:(NSString *)aUrl
{
     NSString *ret = nil;
    ret = [NSString stringWithFormat:@"http://121.199.51.22%@",aUrl];
    return ret;
}
@end
