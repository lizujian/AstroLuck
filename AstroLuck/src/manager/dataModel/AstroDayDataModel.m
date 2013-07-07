//
//  AstroDayDataModel.m
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "AstroDayDataModel.h"

@implementation AstroDayDataModel
//@synthesize name;
//@synthesize validTime;

@synthesize caifuyunshi = _caifuyunshi;
@synthesize jiankang = _jiankang;
@synthesize shangtan = _shangtan;
@synthesize zonghe = _zonghe;
@synthesize shiyexueye = _shiyexueye;
@synthesize xingZuoName = _xingZuoName;
@synthesize yanse = _yanse;
@synthesize time = _time;
@synthesize licai = _licai;
@synthesize shuzi = _shuzi;
@synthesize title = _title;
@synthesize aiqing = _aiqing;
@synthesize supei = _supei;
@synthesize yunshigaishu = _yunshigaishu;
@synthesize aiqingyunshi = _aiqingyunshi;
@synthesize gongzuo = _gongzuo;

-(void)dealloc
{
//    self.name = nil;
//    self.validTime = nil;
    
    [_caifuyunshi release];
    [_jiankang release];
    [_shangtan release];
    [_zonghe release];
    [_shiyexueye release];
    [_xingZuoName release];
    [_yanse release];
    [_time release];
    [_licai release];
    [_shuzi release];
    [_title release];
    [_aiqing release];
    [_supei release];
    [_yunshigaishu release];
    [_aiqingyunshi release];
    [_gongzuo release];
    
    [super dealloc];
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.caifuyunshi forKey:@"caifuyunshi"];
    [mutableDict setValue:self.jiankang forKey:@"jiankang"];
    [mutableDict setValue:self.shangtan forKey:@"shangtan"];
    [mutableDict setValue:self.zonghe forKey:@"zonghe"];
    [mutableDict setValue:self.shiyexueye forKey:@"shiyexueye"];
    [mutableDict setValue:self.xingZuoName forKey:@"xingZuoName"];
    [mutableDict setValue:self.yanse forKey:@"yanse"];
    [mutableDict setValue:self.time forKey:@"time"];
    [mutableDict setValue:self.licai forKey:@"licai"];
    [mutableDict setValue:self.shuzi forKey:@"shuzi"];
    [mutableDict setValue:self.title forKey:@"title"];
    [mutableDict setValue:self.aiqing forKey:@"aiqing"];
    [mutableDict setValue:self.supei forKey:@"supei"];
    [mutableDict setValue:self.yunshigaishu forKey:@"yunshigaishu"];
    [mutableDict setValue:self.aiqingyunshi forKey:@"aiqingyunshi"];
    [mutableDict setValue:self.gongzuo forKey:@"gongzuo"];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

-(void)buildSimulationData
{
//    self.name = @"金牛座";
//    self.validTime = @"2013.6.22";
}

+(id)parseDataFromJSON:(NSDictionary *)data
{
    // 输入参数判断
    if ( nil == data )
        return nil;
    AstroDayDataModel *retObject = [AstroDayDataModel new];
    if ( nil == retObject) {
        return nil;
    }
#ifdef USE_SIMULATION_DATA
    // 构造模拟数据
    [retObject buildSimulationData];
    return [retObject autorelease];
#endif
    
    // 解析真实数据
    retObject.caifuyunshi = [data stringValueForKey:@"caifuyunshi" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.jiankang = [data stringValueForKey:@"jiankang" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.shangtan = [data stringValueForKey:@"shangtan" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.zonghe = [data stringValueForKey:@"zonghe" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.shiyexueye = [data stringValueForKey:@"shiyexueye" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.xingZuoName = [data stringValueForKey:@"xingZuoName" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.yanse = [data stringValueForKey:@"yanse" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.time = [data stringValueForKey:@"time" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.licai = [data stringValueForKey:@"licai" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.shuzi = [data stringValueForKey:@"shuzi" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.title = [data stringValueForKey:@"title" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.aiqing = [data stringValueForKey:@"aiqing" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.supei = [data stringValueForKey:@"supei" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.yunshigaishu = [data stringValueForKey:@"yunshigaishu" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.aiqingyunshi = [data stringValueForKey:@"aiqingyunshi" defaultValue:@"" operation:NSStringOperationTypeTrim];
    retObject.gongzuo = [data stringValueForKey:@"gongzuo" defaultValue:@"" operation:NSStringOperationTypeTrim];
    
    return [retObject autorelease];
}

@end

@implementation AstroToDayDataModel

@end

@implementation AstroTomorrowDataModel

@end
