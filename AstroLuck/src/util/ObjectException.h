//
//  ObjectException.h
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray(ObjectException)

- (id)objectForKey:(id)aKey;

@end

@interface NSMutableArray(ObjectException)

- (id)objectForKey:(id)aKey;

@end

@interface NSDictionary(ObjectException)

- (id)objectAtIndex:(NSUInteger)index;
@end

@interface NSMutableDictionary(ObjectException)

- (id)objectAtIndex:(NSUInteger)index;

- (void)safeSetObject:(id)obj forKey:(id<NSCopying>)key;
@end

@interface NSObject(ObjectException)

- (id)arrayObjectForKey:(NSString*)key withDefaultValue:(id)defaultValue;
- (id)dictObjectForKey:(NSString*)key withDefaultValue:(id)defaultValue;

- (id)objectForKey:(NSString*)key withDefaultValue:(id)defaultValue;
- (id)objectAtIndex:(NSUInteger)index withDefaultValue:(id)defaultValue;

- (void)addObject:(id)anObject withDefaultValue:(id)defaultValue;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index withDetaultValue:(id)defaultValue;
- (void)removeObjectAtIndex:(NSUInteger)index withDefaultValue:(id)defaultValue;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey withDefaultValue:(id)defaultValue;

@end
