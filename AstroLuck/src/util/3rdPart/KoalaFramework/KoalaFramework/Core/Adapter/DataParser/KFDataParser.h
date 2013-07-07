//
//  KFDataParser.h
//  KoalaFramework
//
//  Created by Daly on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#define kModelTypeNSString @"T"

#import <Foundation/Foundation.h>

@interface KFDataParser : NSObject

+ (id)parserData:(NSDictionary*)dataDict;

@end
