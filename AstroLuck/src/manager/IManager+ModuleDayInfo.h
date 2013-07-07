//
//  IManager+ModuleDayInfo.h
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "IManager.h"

@interface IManager (ModuleDayInfo)
-(int64_t) requestTodayAstro:(NSString *)astroName language:(AstroLanguageType)languageType withDelegate:(id<IManagerDelegate>)delegate;

-(int64_t) requestTomorrowAstro:(NSString *)astroName language:(AstroLanguageType)languageType withDelegate:(id<IManagerDelegate>)delegate;
@end
