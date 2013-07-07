//
//  Tap_Marco.h
//  TapTapMonster
//
//  Created by LiZujian on 13-4-30.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#ifndef TapTapMonster_Tap_Marco_h
#define TapTapMonster_Tap_Marco_h

//extension
#import "CGRect+BeeExtension.h"
#import "NSArray+BeeExtension.h"
#import "NSData+BeeExtension.h"
#import "NSDate+BeeExtension.h"
#import "NSDictionary+BeeExtension.h"
#import "NSNumber+BeeExtension.h"
#import "NSObject+BeeProperty.h"
#import "NSObject+BeeTypeConversion.h"
#import "NSString+BeeExtension.h"
#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"
#import "UIImage+BeeExtension.h"

#ifdef __IPHONE_6_0

#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
#define UILineBreakModeClip				NSLineBreakByClipping
#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

#define UITextAlignmentLeft				NSTextAlignmentLeft
#define UITextAlignmentCenter			NSTextAlignmentCenter
#define UITextAlignmentRight			NSTextAlignmentRight

//#define NSTextAlignment                 UITextAlignment
#endif	// #ifdef __IPHONE_6_0

#define SAFE_RELEASE(object) [object release],object=nil;

//单例的宏

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//系统版本
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

//高度，宽度
#define UIScreenHeight     [[UIScreen mainScreen] bounds].size.height
#define UIScreenWidth      [[UIScreen mainScreen] bounds].size.width

#pragma mark -

#define BEE_RELEASE(x) ([(x) release])

#undef	SAFE_RELEASE_SUBLAYER
#define SAFE_RELEASE_SUBLAYER( __x ) \
{ \
[__x removeFromSuperlayer]; \
BEE_RELEASE(__x); \
__x = nil; \
}

#undef	SAFE_RELEASE_SUBVIEW
#define SAFE_RELEASE_SUBVIEW( __x ) \
{ \
[__x removeFromSuperview]; \
BEE_RELEASE(__x); \
__x = nil; \
}

#pragma mark -

typedef enum AstroLanguage {
    AstroLanguageSimple = 0,
    AstroLanguageComplex = 1,
    AstroLanguageEnglish =2
    }AstroLanguageType;

//字体
#define kfontName   @"Marker Felt"

//Umeng appKey
#define UMENG_APPKEY @"51c54a6456240b5f6002260b"

#endif
