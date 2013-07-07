//
//  IDataModel.m
//  Zhidao
//
//  Created by liangqiaozhong on 12-12-13.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import "IDataModel.h"
#import "FrameworkRelativeDefines.h"

@implementation IDataModel

//@synthesize isDataFromOfflinePackage=_isDataFromOfflinePackage;
//@synthesize jsonValue               =_jsonValue;
//@synthesize dbKey                   =_dbKey;
//@synthesize isDataFromDB            =_isDataFromDB;

// 将JSON数据解析为数据模型,此处为空实现，需要具体的IDataModel子类重载实现
//-(id) parseDataFromJSON:(NSDictionary*)data
//{
//    return [[self class] parseDataFromJSON:data];
//}

+ (id)parseDataFromJSON:(NSDictionary *)data
{
    return nil;
}

- (void)buildSimulationData
{
    
}

-(NSDictionary *)dictionaryRepresentation
{
    return nil;
}


-(void) saveInDB
{
#pragma mark  需要异步操作
//    [[AlbumDBOperator sharedInstance] saveJson:self.jsonValue withKey:self.dbKey];
}

-(void) dealloc
{
//    [_dbKey release];
//    [_jsonValue release];
    [super dealloc];
}
@end
