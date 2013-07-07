//
//  KFBaseModel.m
//  KoalaFramework
//
//  Created by Daly on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "KFBaseModel.h"
#import <objc/runtime.h>

@implementation KFBaseModel {
	NSMutableDictionary *_extdata;
}

- (id)init
{
	if (self = [super init]) {
		_extdata = [NSMutableDictionary new];
	}
	return self;
}
- (void)addExtValue:(id)value forKey:(NSString *)key
{
	[_extdata setObject:value forKey:key];
}

- (id)extValueForKey:(NSString *)key
{
	return [_extdata objectForKey:key];
}
- (NSDictionary*)extDict
{
    return _extdata;

}
- (void)dealloc
{
	[_extdata release];
	[super dealloc];
}

//- (NSString *)description
//{
//	return [super description];
//}
- (NSString*)description
{
    NSString * rc = [super description];
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
//    for (i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        NSString *propName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        NSString *value = [self valueForKey:propName];
//        rc = [NSString stringWithFormat:@"%@ ;\r%@ = %@", rc,propName,value];
//
//    }
    return rc;
}

- (BOOL) isValid
{
    BOOL rc = TRUE;
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
        NSString *propName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:propName];
        NSString *strAttr = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        NSArray* typeArr = [strAttr componentsSeparatedByString:@"\""];  
        
        for(NSString* clazzName in typeArr){
            if ([clazzName rangeOfString:@"model"].length > 0){
                // 是自定义的model
                Class clazz = NSClassFromString(clazzName);
                if (value && ![value isKindOfClass:clazz]){
                    rc = false;
                }
            }
        }
    }
    
    return rc;
}

@end
