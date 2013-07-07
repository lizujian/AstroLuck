//
//  KFRuntimeDebug.h
//  KoalaFramework
//
//  Created by JHorn.Han on 12/12/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//


#pragma mark -


#pragma mark -

#undef	AS_STATIC_PROPERTY
#define AS_STATIC_PROPERTY( __name ) \
@property (nonatomic, readonly) NSString * __name; \
+ (NSString *)__name;

#undef	DEF_STATIC_PROPERTY
#define DEF_STATIC_PROPERTY( __name ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [[NSString stringWithFormat:@"%s", #__name] retain]; \
} \
return __local; \
}

#undef	DEF_STATIC_PROPERTY2
#define DEF_STATIC_PROPERTY2( __name, __prefix ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [[NSString stringWithFormat:@"%@.%s", __prefix, #__name] retain]; \
} \
return __local; \
}

#undef	DEF_STATIC_PROPERTY3
#define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [[NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name] retain]; \
} \
return __local; \
}

#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( __name ) \
@property (nonatomic, readonly) NSInteger __name; \
+ (NSInteger)__name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( __name, __value ) \
@dynamic __name; \
+ (NSInteger)__name \
{ \
return __value; \
}

#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT


#undef	AS_STATIC_PROPERTY_STRING
#define AS_STATIC_PROPERTY_STRING( __name ) \
@property (nonatomic, readonly) NSString * __name; \
+ (NSString *)__name;

#undef	DEF_STATIC_PROPERTY_STRING
#define DEF_STATIC_PROPERTY_STRING( __name, __value ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
return __value; \
}

#undef	AS_STRING
#define AS_STRING	AS_STATIC_PROPERTY_STRING

#undef	DEF_STRING
#define DEF_STRING	DEF_STATIC_PROPERTY_STRING


#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	 [KFRuntimeDebug printCallstack:__n]

#pragma mark -

@interface CFFCllFrame : NSObject
{
	NSUInteger			_type;
	NSString *			_process;
	NSUInteger			_entry;
	NSUInteger			_offset;
	NSString *			_clazz;
	NSString *			_method;
}

AS_INT( TYPE_UNKNOWN )
AS_INT( TYPE_OBJC )
AS_INT( TYPE_NATIVEC )

@property (nonatomic, assign) NSUInteger	type;
@property (nonatomic, retain) NSString *	process;
@property (nonatomic, assign) NSUInteger	entry;
@property (nonatomic, assign) NSUInteger	offset;
@property (nonatomic, retain) NSString *	clazz;
@property (nonatomic, retain) NSString *	method;

+ (id)parse:(NSString *)line;
+ (id)unknown;

@end

#pragma mark -

@interface KFRuntimeDebug : NSObject

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;

+ (NSArray *)callstack:(NSUInteger)depth;
+ (NSArray *)callframes:(NSUInteger)depth;

+ (void)printCallstack:(NSUInteger)depth;

@end
