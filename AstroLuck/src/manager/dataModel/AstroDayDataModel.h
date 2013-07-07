//
//  AstroDayDataModel.h
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "IDataModel.h"

@interface AstroDayDataModel : IDataModel

//@property(nonatomic, retain)NSString *name;
//@property(nonatomic, retain)NSString *validTime;

@property (nonatomic, retain) NSString *caifuyunshi;
@property (nonatomic, retain) NSString *jiankang;
@property (nonatomic, retain) NSString *shangtan;
@property (nonatomic, retain) NSString *zonghe;
@property (nonatomic, retain) NSString *shiyexueye;
@property (nonatomic, retain) NSString *xingZuoName;
@property (nonatomic, retain) NSString *yanse;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *licai;
@property (nonatomic, retain) NSString *shuzi;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *aiqing;
@property (nonatomic, retain) NSString *supei;
@property (nonatomic, retain) NSString *yunshigaishu;
@property (nonatomic, retain) NSString *aiqingyunshi;
@property (nonatomic, retain) NSString *gongzuo;

@end

@interface AstroToDayDataModel : AstroDayDataModel

@end

@interface AstroTomorrowDataModel : AstroDayDataModel

@end
