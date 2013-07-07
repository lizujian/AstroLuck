//
//  KFDatabaseService.m
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFDatabaseService.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

@implementation KFColumnTypePair

@synthesize column = _column, type = _type;

- (id)init {
    if (self = [super init]) {
        _column = @"unknown_init";
        _type = KFDBTableColumnTypeText;
    }
    return self;
}

- (id)initWithColumn:(NSString*)column type:(KFDBTableColumnType)type {
    if (self = [super init]) {
        _column = [column retain];
        _type = type;
    }
    return self;
}

- (void)dealloc {
    KF_RELEASE_SAFELY(_column);
    [super dealloc];
}

- (NSString*)columnTypeInTable {
    switch(_type) {
        case KFDBTableColumnTypeText: {
            return @"text";
        }
        case KFDBTableColumnTypeDouble: {
            return @"double";
        }
        case KFDBTableColumnTypeInteger: {
            return @"int";
        }
        case KFDBTableColumnTypeBool: {
            return @"bool";
        }
        case KFDBTableColumnTypeDate: {
            return @"text";
        }
        case KFDBTableColumnTypeData: {
            return @"text";
        }
        default: {
            return nil;
        }
    }
}

@end


static KFDatabaseService *singleton;

@interface KFDatabaseService () {
    FMDatabase *__database;
    NSString   *__databaseName;
}

@property (nonatomic, copy) NSString *databaseName;

- (void)clearInstance;
- (NSString*)getPathWithDBName:(NSString*)dbName;
- (void)connectDB;
- (void)closeDB;
- (void)createTable:(id<KFDatabaseDelegate>)delegate;

@end


@implementation KFDatabaseService

@synthesize databaseName = __databaseName;

#pragma mark -
#pragma mark singleton methods

+ (KFDatabaseService*)GetInstance {
    if (nil == singleton) {
        @synchronized(self) {
            singleton = [[super allocWithZone:NULL] init];
        }
    }
    return singleton;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [[self GetInstance] retain];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    // do nothing here
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark object method

- (id)init {
    if (self = [super init]) {
        KFLog(@"init");
        [self switchToDBWithDBName:nil];
    }
    return self;
}

- (void)dealloc {
    KFLog(@"KFDatabaseService dealloc");
    [self closeDB];
    [super dealloc];
}

#pragma mark -
#pragma mark Class method

- (void)clearInstance {
	if (singleton) {
        [singleton closeDB];
		singleton = nil;
	}
    //KFLog(@"singleton: %@", singleton);
}

#pragma mark -
#pragma mark object private

// ------------------------------------------------
// path for database is ~/Library/KFCaches/DB
// ------------------------------------------------
- (NSString*)getPathWithDBName:(NSString*)dbName {
    NSArray *arrayOfPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arrayOfPaths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"KFCaches"];
    if ([KFDatabaseService createDirectory:path]) {
        path = [path stringByAppendingPathComponent:@"DB"];
        if ([KFDatabaseService createDirectory:path]) {
            path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", (dbName == nil) ? @"default" : dbName]];
            return path;
        }
        else {
            KFLog(@"path: %@ not exist", path);
        }
    }
    else {
        KFLog(@"path: %@ not exist", path);
    }
    return nil;
}


// 连接数据库
- (void)connectDB {
    KFLog(@"KFDatabaseService connectDBWithDBName:[%@]", self.databaseName);
    NSString *path = [self getPathWithDBName:self.databaseName];
    if (path != nil && [path length] > 0) {
        __database = [[FMDatabase databaseWithPath:path] retain];
        if (![__database open]) {
            KFLog(@"can not open database!");
        }
    }
}


// 关闭数据库
- (void)closeDB {
    KFLog(@"KFDatabaseService closeDB");
    [__database close];
    KF_RELEASE_SAFELY(__database);
    KF_RELEASE_SAFELY(__databaseName);
}

#pragma mark -
#pragma mark object Public


// 切换数据库.sqlite文件至指定文件
- (void)switchToDBWithDBName:(NSString*)dbName {
    @synchronized(self) {
        KFLog(@"dbName: %@, %@", dbName, self.databaseName);
        if ([self.databaseName length] > 0) {
            if (!([dbName length] > 0 && [dbName isEqualToString:self.databaseName])) {
                [self clearInstance];
                self.databaseName = dbName;
                [self connectDB];
            }
        }
        else {
            self.databaseName = dbName;
            [self connectDB];
        }
    }
}

// 删除某个数据库文件,传nil时删除默认数据库文件
- (BOOL)removeDBWithDBName:(NSString*)dbName {
    @synchronized(self) {
        [self clearInstance];
        NSString *path = [self getPathWithDBName:dbName];
        
        if (path == nil || [path length] == 0) {
            return FALSE;
        }
        
        NSError *error;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        return [fileMgr removeItemAtPath:path error:&error];
    }
}

// 创建数据表，要求delegate实现 tableName, keyConfigureArray, valueConfigureArray方法
- (void)createTable:(id<KFDatabaseDelegate>)delegate {
    if (delegate != nil) {
        NSMutableString *sql = [NSMutableString stringWithCapacity:20];
        NSMutableString *primaryKey = [NSMutableString stringWithCapacity:20];
        
        NSMutableArray *keyConfigureArray = [delegate keyConfigureArray];
        NSMutableArray *valueConfigureArray = [delegate valueConfigureArray];
        
        if (keyConfigureArray != nil && [keyConfigureArray count] > 0) {
            [sql appendFormat:@"CREATE TABLE if not exists Table_%@ (", [delegate tableName]];
            [primaryKey appendString:@"PRIMARY KEY("];
            int i = 0;
            for (id keyConfigure in keyConfigureArray) {
                if ([keyConfigure isKindOfClass:[KFColumnTypePair class]]) {
                    KFColumnTypePair *keyConf = (KFColumnTypePair*)keyConfigure;
                    if (i > 0) {
                        [sql appendString:@", "];
                        [primaryKey appendString:@", "];
                    }
                    ++i;
                    [sql appendFormat:@"%@ %@", keyConf.column, [keyConf columnTypeInTable]];
                    [primaryKey appendFormat:@"%@", keyConf.column];
                }
            }
            [primaryKey appendString:@")"];
            if (valueConfigureArray != nil && [valueConfigureArray count] > 0) {
                for (id valueConfigure in valueConfigureArray) {
                    if ([valueConfigure isKindOfClass:[KFColumnTypePair class]]) {
                        KFColumnTypePair *valueConf = (KFColumnTypePair*)valueConfigure;
                        [sql appendFormat:@", %@ %@", valueConf.column, [valueConf columnTypeInTable]];
                    }
                }
            }
            [sql appendFormat:@", %@)", primaryKey];
            
            // KFLog(@"sql create table: %@", sql);
            // i.e.
            // CREATE TABLE if not exists Table_adapter_1 (key_0 text, key_1 text, key_2 text, data text, timestamp double, etag text, PRIMARY KEY(key_0, key_1, key_2))
            
            @synchronized(__database) {
                [__database executeUpdate:sql];
            }
        }
    }
}

// REPLACE INTO Table_adapter_1 (key_0, key_1, key_2, data, timestamp, etag) VALUES(?, ?, ?, ?, ?, ?), arguments需要依次填写入所有keys, values对应内容
- (BOOL)insertIntoTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments {
    if (delegate != nil) {
        [self createTable:delegate];
        NSMutableString *sql = [NSMutableString stringWithCapacity:20];
        NSMutableString *valueMasks = [NSMutableString stringWithCapacity:20];
        
        NSMutableArray *keyConfigureArray = [delegate keyConfigureArray];
        NSMutableArray *valueConfigureArray = [delegate valueConfigureArray];
        
        if (keyConfigureArray != nil && [keyConfigureArray count] > 0) {
            [sql appendFormat:@"REPLACE INTO Table_%@ (", [delegate tableName]];
            [valueMasks appendString:@"VALUES("];
            int i = 0;
            for (id keyConfigure in keyConfigureArray) {
                if ([keyConfigure isKindOfClass:[KFColumnTypePair class]]) {
                    KFColumnTypePair *keyConf = (KFColumnTypePair*)keyConfigure;
                    if (i > 0) {
                        [sql appendString:@", "];
                        [valueMasks appendString:@", "];
                    }
                    ++i;
                    [sql appendFormat:@"%@", keyConf.column];
                    [valueMasks appendString:@"?"];
                }
            }
            
            if (valueConfigureArray != nil && [valueConfigureArray count] > 0) {
                for (id valueConfigure in valueConfigureArray) {
                    if ([valueConfigure isKindOfClass:[KFColumnTypePair class]]) {
                        KFColumnTypePair *valueConf = (KFColumnTypePair*)valueConfigure;
                        [sql appendFormat:@", %@", valueConf.column];
                        [valueMasks appendString:@", ?"];
                    }
                }
            }
            [valueMasks appendString:@")"];
            [sql appendFormat:@") %@", valueMasks];
            
            //KFLog(@"sql insert: %@", sql);
            // i.e.
            // REPLACE INTO Table_adapter_1 (key_0, key_1, key_2, data, timestamp, etag) VALUES(?, ?, ?, ?, ?, ?)
            @synchronized(__database) {
                return [__database executeUpdate:sql withArgumentsInArray:arguments];
            }
        }
    }
    
    return FALSE;
}

// UPDATE Table_adapter_1 SET updateKey = updateValue WHERE key_0 = ? AND key_1 = ? AND key_2 = ?, arguments只能依次传入keys值，比如一共有(key_0, key_1, key_2), arguments可以是key_0, 或 (key_0, key_1), 或（key_0, key_1, key_2)
- (BOOL)updateTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments updateKey:(NSString*)updateKey updateValue:(id)updateValue {
    if (delegate != nil) {
        [self createTable:delegate];
        NSMutableString *sql = [NSMutableString stringWithCapacity:20];
        NSMutableString *conditionSql = [NSMutableString stringWithCapacity:20];
        
        NSMutableArray *keyConfigureArray = [delegate keyConfigureArray];
        
        if (keyConfigureArray != nil && [keyConfigureArray count] > 0) {
            int i = 0;
            for (id keyConfigure in keyConfigureArray) {
                if (i >= [arguments count]) {
                    break;
                }
                if ([keyConfigure isKindOfClass:[KFColumnTypePair class]]) {
                    KFColumnTypePair *keyConf = (KFColumnTypePair*)keyConfigure;
                    if (i > 0) {
                        [conditionSql appendString:@" AND "];
                    }
                    ++i;
                    [conditionSql appendFormat:@"%@ = ?", keyConf.column];
                }
            }
            
            [sql appendFormat:@"UPDATE Table_%@ SET %@ = \"%@\" WHERE %@", [delegate tableName], updateKey, updateValue, conditionSql];
            //KFLog(@"sql update: %@", sql);
            
            // i.e.
            // UPDATE Table_adapter_1 SET timestamp = 2.3 WHERE key_0 = ? AND key_1 = ? AND key_2 = ?
            @synchronized(__database) {
                return [__database executeUpdate:sql withArgumentsInArray:arguments];
            }
        }
    }
    return FALSE;
}


// SELECT * FROM Table_adapter_1 WHERE key_0 = ? AND key_1 = ? AND key_2 = ?, arguments只能依次传入keys值，比如一共有(key_0, key_1, key_2), arguments可以是key_0, 或 (key_0, key_1), 或（key_0, key_1, key_2)
- (NSMutableArray*)selectFromTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments { // arguments must be part of primary key, not value
    NSMutableArray *resultArray = nil;
    if (delegate != nil) {
        [self createTable:delegate];
        NSMutableString *sql = [NSMutableString stringWithCapacity:20];
        NSMutableArray *keyConfigureArray = [delegate keyConfigureArray];
        NSMutableArray *valueConfigureArray = [delegate valueConfigureArray];
        
        if (keyConfigureArray != nil && [keyConfigureArray count] > 0) {
            [sql appendFormat:@"SELECT * FROM Table_%@", [delegate tableName]];
            int i = 0;
            for (id keyConfigure in keyConfigureArray) {
                if (i >= [arguments count]) {
                    break;
                }
                else if (i == 0) {
                    [sql appendString:@" WHERE "];
                }
                if ([keyConfigure isKindOfClass:[KFColumnTypePair class]]) {
                    KFColumnTypePair *keyConf = (KFColumnTypePair*)keyConfigure;
                    if (i > 0) {
                        [sql appendString:@" AND "];
                    }
                    ++i;
                    [sql appendFormat:@"%@ = ?", keyConf.column];
                }
            }
            
            //            KFLog(@"sql select: %@", sql);
            // i.e.
            // SELECT * FROM Table_adapter_1 WHERE key_0 = ? AND key_1 = ? AND key_2 = ?
            @synchronized(__database) {
                FMResultSet *res = nil;
                res = [__database executeQuery:sql withArgumentsInArray:arguments];
                resultArray = [[[NSMutableArray alloc] init] autorelease];
                while ([res next]) {
                    NSMutableDictionary *resultDict = [[[NSMutableDictionary alloc] init] autorelease];
                    if (valueConfigureArray != nil && [valueConfigureArray count] > 0) {
                        for (id keyConfigure in keyConfigureArray) {
                            if ([keyConfigure isKindOfClass:[KFColumnTypePair class]]) {
                                KFColumnTypePair *keyConf = (KFColumnTypePair*)keyConfigure;
                                [resultDict setValue:[res stringForColumn:keyConf.column] forKey:keyConf.column];
                            }
                        }
                        for (id valueConfigure in valueConfigureArray) {
                            if ([valueConfigure isKindOfClass:[KFColumnTypePair class]]) {
                                KFColumnTypePair *valueConf = (KFColumnTypePair*)valueConfigure;
                                switch (valueConf.type) {
                                    case KFDBTableColumnTypeData: {
                                        [resultDict setValue:[res dataForColumn:valueConf.column] forKey:valueConf.column];
                                        break;
                                    }
                                    default: {
                                        [resultDict setValue:[res stringForColumn:valueConf.column] forKey:valueConf.column];
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if ([resultDict count] > 0) {
                        [resultArray addObject:resultDict];
                    }
                }
                [res close];
            }
        }
    }
    return resultArray;
}

// DELETE FROM Table_adapter_1 WHERE key_0 = ? AND key_1 = ? AND key_2 = ?, arguments只能依次传入keys值，比如一共有(key_0, key_1, key_2), arguments可以是key_0, 或 (key_0, key_1), 或（key_0, key_1, key_2), arguments为 nil 时表示删除所有内容
- (BOOL)deleteFromTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments {
    if (delegate != nil) {
        [self createTable:delegate];
        NSMutableString *sql = [NSMutableString stringWithCapacity:20];
        NSMutableArray *keyConfigureArray = [delegate keyConfigureArray];
        
        if (keyConfigureArray != nil && [keyConfigureArray count] > 0) {
            [sql appendFormat:@"DELETE FROM Table_%@", [delegate tableName]];
            int i = 0;
            for (id keyConfigure in keyConfigureArray) {
                if (arguments == nil || [arguments count] == 0) {
                    break;
                }
                
                if (i == 0) {
                    [sql appendFormat:@" WHERE "];
                }
                else if (i >= [arguments count]) {
                    break;
                }
                if ([keyConfigure isKindOfClass:[KFColumnTypePair class]]) {
                    KFColumnTypePair *keyConf = (KFColumnTypePair*)keyConfigure;
                    if (i > 0) {
                        [sql appendString:@" AND "];
                    }
                    ++i;
                    [sql appendFormat:@"%@ = ?", keyConf.column];
                }
            }
            
            //            KFLog(@"sql delete: %@", sql);
            // i.e.
            // DELETE FROM Table_adapter_1 WHERE key_0 = ? AND key_1 = ? AND key_2 = ?
            // DELETE FROM Table_adapter_1    means delete all
            @synchronized(__database) {
                return [__database executeUpdate:sql withArgumentsInArray:arguments];
            }
        }
    }
    return FALSE;
}


+ (BOOL)createDirectory:(NSString*)path {
    if (nil == path || 0 == [path length]) {
        return NO;
    }
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        //KFLog(@"Already exist: %@", path);
        return YES;
    }
    else {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            //  KFLog(@"Fail to create %@, because of: %@", path, [error description]);
            return NO;
        }
        else {
            //  KFLog(@"Succeed to create %@", path);
            return YES;
        }
    }
}

@end
