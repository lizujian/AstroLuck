//
//  KDataParser.m
//  KoalaFramework
//
//  Created by Daly on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "KFDataParser.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "KFBaseModel.h"
@implementation KFDataParser

+ (id)modelWithDictionary:(NSDictionary *)dict
{
	if (![dict objectForKey:kModelTypeNSString]) return nil; // No Type, dismiss it
	NSString *className = [dict objectForKey:kModelTypeNSString];
	Class clazz = NSClassFromString([NSString stringWithFormat:@"%@Model",className]);
	if (![clazz isSubclassOfClass:[KFBaseModel class]]) {
        NSAssert(NO, @"Name is %@Model class is not exist!",className);
        return nil;
    }// Invalid model
    
	KFBaseModel *model = [clazz new];
	for (NSString *key in [dict allKeys]) {
		id value = [dict objectForKey:key];
		if ([value isKindOfClass:[NSDictionary class]]) {
			KFBaseModel *modelValue = [self modelWithDictionary:value];
            if (!modelValue) {
                [KFDataParser setProperty:key withValue:[self dictionaryWithDict:value] forModel:model];
            } else {
                [KFDataParser setProperty:key withValue:modelValue forModel:model];
            }
		} else if ([value isKindOfClass:[NSArray class]]) {
			NSMutableArray *arrValue = [NSMutableArray array];
			for (id item in value) {
				if (![item isKindOfClass:[NSDictionary class]] && ![item isKindOfClass:[NSArray class]]) {
					[arrValue addObject:item];
				} else {
					KFBaseModel *modelValue = [KFDataParser modelWithDictionary:item];
					[arrValue addObject:modelValue];
				}
			}
			[self setProperty:key withValue:arrValue forModel:model];
		} else {
			[self setProperty:key withValue:value forModel:model];
		}
	}
	return [model autorelease];
}

+ (NSString *)setterNameWithPropertyName:(NSString *)propName
{
	NSString *firstChar = [propName substringToIndex:1];
	firstChar = [firstChar capitalizedString];
	return [propName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstChar];
}

+ (void)setProperty:(NSString *)propName withValue:(id)value forModel:(KFBaseModel *)model
{
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
	NSString *setterName = [NSString stringWithFormat:@"set%@:", [KFDataParser setterNameWithPropertyName:propName]];
	SEL setter = NSSelectorFromString(setterName);
	if ([model respondsToSelector:setter]) {
		objc_property_t property = class_getProperty([model class], [propName cStringUsingEncoding:NSUTF8StringEncoding]);
#if Debug_Model_Factory
        NSLog(@"propName = %@",propName);
#endif
		const char *attr = property_getAttributes(property);
		NSString *strAttr = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];
#if Debug_Model_Factory
        NSLog(@"%@",strAttr);
#endif
		NSString *varType = [[[strAttr componentsSeparatedByString:@","] objectAtIndex:0] substringFromIndex:1];
		if ([varType isEqualToString:@"d"]) {
			objc_msgSend(model, setter, [value doubleValue]);
		} else if ([varType isEqualToString:@"f"]) {
			objc_msgSend(model, setter, [value floatValue]);
		} else if ([varType isEqualToString:@"i"]) {
			objc_msgSend(model, setter, [value intValue]);
		} else if ([varType isEqualToString:@"q"]) {
			objc_msgSend(model, setter, [value longLongValue]);
		} else if ([varType isEqualToString:@"c"]) {
			objc_msgSend(model, setter, [value boolValue]);
		} else {
            objc_msgSend(model, setter, value);
		}
	} else {
        
        if ([model respondsToSelector:@selector(addExtValue:forKey:)])
            [model addExtValue:value forKey:propName];
	}
}


+ (id)parserArray:(NSArray*)anArray
{
	NSMutableArray *array = [NSMutableArray array];
    for (id item in anArray) {
        id value = nil;
        if ([item isKindOfClass:[NSArray class]]) {
            
        } else if ([item isKindOfClass:[NSDictionary class]]) {
            value = [KFDataParser parserData:item];
        } else {
            value = item;
        }
		if (value)
		{
			[array addObject:value];
		}
	}
	return array;

}

+ (id)parserValue:(id)value
{
    if ([value isKindOfClass:[NSArray class]]) {
        return [KFDataParser parserArray:value];
    } else if([value isKindOfClass:[NSDictionary class]]) {
        return [KFDataParser parserData:value];
    } else {
        return value;
    }
}

+ (NSDictionary *)dictionaryWithDict:(NSDictionary *)inDict
{
	if (inDict == nil) return nil;
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *propName in [inDict allKeys]) {
        id value = [KFDataParser parserValue:[inDict objectForKey:propName]];
        if (value) {
            [dict setObject:value forKey:propName];
        }
    
    }
    
	return dict;
}



+ (id)parserData:(NSDictionary*)dataDict
{
    
    
    
    if (dataDict == nil) return nil;
    NSString *modelTypeKey =[dataDict objectForKey:kModelTypeNSString];
	if (modelTypeKey) {
		return [KFDataParser modelWithDictionary:dataDict];
	} else {
		return [KFDataParser dictionaryWithDict:dataDict];
	}
}
@end
