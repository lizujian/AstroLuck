//
//  ObjectException.m
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "ObjectException.h"


#define kSupportThrowException  1


@implementation NSArray(ObjectException)

- (id)objectForKey:(id)aKey
{
#if !kSupportThrowException
    return nil;
#endif
    @throw @"NSArray:objectForKey";
}

@end

@implementation NSMutableArray(ObjectException)

- (id)objectForKey:(id)aKey
{
#if !kSupportThrowException
    return nil;
#endif
    @throw @"NSMutableArray:objectForKey";
}

@end

@implementation NSDictionary(ObjectException)

- (id)objectAtIndex:(NSUInteger)index
{
#if !kSupportThrowException
    return nil;
#endif
    @throw @"NSDictionary:objectAtIndex";
}


@end

@implementation NSMutableDictionary(ObjectException)

- (id)objectAtIndex:(NSUInteger)index
{
#if !kSupportThrowException
    return nil;
#endif
    @throw @"NSMutableDictionary:objectAtIndex";
}

-(void)safeSetObject:(id)obj forKey:(id<NSCopying>)key
{
    if (obj != nil) {
        [self setObject:obj forKey:key];
    }
    else
    {
        //假如是空，直接写入一个空字符串
        [self setObject:@"" forKey:key];
    }
}

@end

@implementation NSObject(ObjectException)

- (id)arrayObjectForKey:(NSString*)key withDefaultValue:(id)defaultValue
{
    NSDictionary *dict = (NSDictionary*)self;
    
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        NSArray *arr = [dict objectForKey:key];
        
        if ([arr isKindOfClass:[NSArray class]])
        {
            return arr;
        }
    }
    
    return defaultValue;
}

- (id)dictObjectForKey:(NSString*)key withDefaultValue:(id)defaultValue
{
    NSDictionary *dict = (NSDictionary*)self;
    
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictReturn = [dict objectForKey:key];
        
        if ([dictReturn isKindOfClass:[NSDictionary class]])
        {
            return dictReturn;
        }
    }
    
    return defaultValue;
}

- (id)objectForKey:(NSString*)key withDefaultValue:(id)defaultValue
{
    NSDictionary *dict = (NSDictionary*)self;
    
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        return [dict objectForKey:key];
    }
    
    return defaultValue;
}

- (id)objectAtIndex:(NSUInteger)index withDefaultValue:(id)defaultValue
{
    if ((int)index < 0)
    {
        return defaultValue;
    }
    
    if ([self respondsToSelector:@selector(count)]
        && [self respondsToSelector:@selector(objectAtIndex:)])
    {
        if ([self count] > (int)index)
        {
            return [self objectAtIndex:(int)index];
        }
    }
    
    return defaultValue;
}

- (void)addObject:(id)anObject withDefaultValue:(id)defaultValue
{
    if ([self respondsToSelector:@selector(addObject:)])
    {
        if (anObject)
        {
            [self performSelector:@selector(addObject:)
                       withObject:anObject];
        }
        else if(defaultValue)
        {
            [self performSelector:@selector(addObject:)
                       withObject:defaultValue];
        }
        
    }
    
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index withDetaultValue:(id)defaultValue
{
    if ((int)index < 0)
    {
        return;
    }
    NSMutableArray *arr = (NSMutableArray*)self;
    
    if (index <= [arr count])
    {
        if ([arr isKindOfClass:[NSMutableArray class]])
        {
            if (anObject)
            {
                [arr insertObject:anObject atIndex:index];
            }
            else
            {
                if (defaultValue)
                {
                    [arr insertObject:defaultValue atIndex:index];
                }
            }
        }
        else
        {
            if (anObject)
            {
                [arr insertObject:anObject atIndex:index];
            }
            else if(defaultValue)
            {
                [arr insertObject:defaultValue atIndex:index];
            }
        }
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index withDefaultValue:(id)defaultValue
{
    if ((int)index < 0)
    {
        return;
    }
    
    NSMutableArray *arr = (NSMutableArray*)self;
    
    if (index <= [arr count] && 0 != [arr count])
    {
        if ([arr respondsToSelector:@selector(removeObjectAtIndex:)])
        {
            [arr removeObjectAtIndex:index];
        }
    }
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey withDefaultValue:(id)defaultValue
{
    if ([self respondsToSelector:@selector(setObject:forKey:)] && aKey)
    {
        if (anObject)
        {
            [self performSelector:@selector(setObject:forKey:)
                       withObject:anObject
                       withObject:aKey];
        }
        else if(defaultValue)
        {
            [self performSelector:@selector(setObject:forKey:)
                       withObject:defaultValue
                       withObject:aKey];
        }
    }
}


@end
