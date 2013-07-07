//
//  KFRequestCodeSignerDelegate.h
//  KoalaFramework
//
//  Created by JHorn.Han on 11/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//


@protocol KFRequestCodeSignerDelegate <NSObject>

-(id)requestCodeSignForParamerter:(NSString*)urlpara
                        withToken:(NSString*)prodctToken
                         postData:(NSDictionary*)postdata;


-(NSString*)productToken;

@end


