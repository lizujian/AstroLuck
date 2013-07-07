//
//  AppDatabase.m
//  groove-iphone
//
//  Created by Craig Jolicoeur on 5/5/11.
//  Copyright 2011 Mojo Tech, LLC. All rights reserved.
//

#import "AppDatabase.h"

@interface AppDatabase(PrivateMethods)
- (void)runMigrations;
-(NSUInteger)databaseVersion;
- (void)setDatabaseVersion:(NSUInteger)newVersionNumber;

// Migration steps - v1
- (void)createApplicationPropertiesTable;

// Migration steps - v2 .. vN
@end



@implementation AppDatabase

+ (NSString *)defaultStoreName
{
    NSString *defaultName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    
    return [defaultName stringByAppendingString:@".sqlite"];
}

- (id)initWithMigrations
{
	self = [self initWithMigrations:NO];

	if (!self)
        return nil;
	
	return self;
}

- (id)initWithMigrations:(BOOL)loggingEnabled
{
    
	self = [super initWithFileName:[AppDatabase defaultStoreName]];
    
	if (!self)
        return nil;

	[self setLogging:loggingEnabled];
	[self runMigrations];
	[MojoModel setDatabase:self];

	return self;
}

- (void)runMigrations
{
	// Turn on Foreign Key support
	[self executeSql:@"PRAGMA foreign_keys = ON"];
	
	NSArray *tableNames = [self tableNames];
	
	if (![tableNames containsObject:@"ApplicationProperties"])
		[self createApplicationPropertiesTable];
    
	if ([self databaseVersion] < 2)
		// Migrations for database version 1 will run here
        [self setDatabaseVersion:2];
	
	/* 
	 * To upgrade to version 3 of the DB do
	
		if ([self databaseVersion] < 3) {
			// ...
			[self setDatabaseVersion:3];
		}
	
	 *
	 */
}

#pragma mark - Migration Steps

- (void) createApplicationPropertiesTable
{
	[self executeSql:@"create table ApplicationProperties (primaryKey integer primary key autoincrement, name text, value integer)"];
	[self executeSql:@"insert into ApplicationProperties (name, value) values('databaseVersion', 1)"];
}

-(void)createAstroDataModelTable
{
    [self executeSql:@"CREATE TABLE AstroDataModel (primaryKey INTEGER primary key autoincrement,\
     astroNum integer,name text,availableTime text,generalRate integer,loveRate integer,jobRate integer,moneyRate integer,healthRate integer,finacalRate integer,luckyNum integer,luckColor text,matchPair text,generalText text,loveText text,jobText text,moneyText text)"];
}


#pragma mark - Convenience Methods

- (void)updateApplicationProperty:(NSString *)propertyName value:(id)value
{
	[self executeSqlWithParameters:@"UPDATE ApplicationProperties SET value = ? WHERE name = ?", value, propertyName, nil];
}

- (id)getApplicationProperty:(NSString *)propertyName
{
	NSArray *rows = [self executeSqlWithParameters:@"SELECT value FROM ApplicationProperties WHERE name = ?", propertyName, nil];
	
	if ([rows count] == 0)
		return nil;
	
	id object = [[rows lastObject] objectForKey:@"value"];
    
	if ([object isKindOfClass:[NSString class]])
		object = [NSNumber numberWithInteger:[(NSString *)object integerValue]];

	return object;
}

- (void)setDatabaseVersion:(NSUInteger)newVersionNumber
{
	return [self updateApplicationProperty:@"databaseVersion" value:[NSNumber numberWithUnsignedInteger:newVersionNumber]];
}

-(NSUInteger)databaseVersion
{
	return [[self getApplicationProperty:@"databaseVersion"] unsignedIntegerValue];
}

@end
