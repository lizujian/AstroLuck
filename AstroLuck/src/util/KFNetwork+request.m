//
//  KFNetwork+request.m
//  BaiduTravel
//
//  Created by LiZujian on 13-2-22.
//  Copyright (c) 2013年 Baidu.com. All rights reserved.
//

#import "KFNetwork+request.h"

@implementation KFNetwork (request)
-(u_int64_t)addRequestCount
{
    NSNumber *requestCountNumber = [self valueForKeyPath:@"_requestCount"];
    NSLog(@"requestCountNumber = %@",requestCountNumber);
    u_int64_t oldRequestCount = [requestCountNumber unsignedLongLongValue];
    u_int64_t newRequestCount = oldRequestCount+1;
    requestCountNumber = [NSNumber numberWithUnsignedLongLong:newRequestCount];
    [self setValue:requestCountNumber forKeyPath:@"_requestCount"];
    return oldRequestCount;
}
@end
