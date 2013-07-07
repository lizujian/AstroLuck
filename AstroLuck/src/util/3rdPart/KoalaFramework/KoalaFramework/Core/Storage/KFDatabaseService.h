//
//  KFDatabaseService.h
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

@class FMDatabase;

typedef enum {
    KFDBTableColumnTypeInteger,
    KFDBTableColumnTypeDouble,
    KFDBTableColumnTypeText,
    KFDBTableColumnTypeDate,
    KFDBTableColumnTypeBool,
    KFDBTableColumnTypeData,
} KFDBTableColumnType;


@interface KFColumnTypePair : NSObject {
    NSString *_column;
    KFDBTableColumnType _type;
}

@property (nonatomic, copy) NSString *column;
@property (nonatomic, assign) KFDBTableColumnType type;

- (id)initWithColumn:(NSString*)column type:(KFDBTableColumnType)type;
- (NSString*)columnTypeInTable;

@end


@protocol KFDatabaseDelegate <NSObject>

@required

// key项配置
@property (nonatomic, retain) NSMutableArray *keyConfigureArray;   // <name, type> pair

// value项配置
@property (nonatomic, retain) NSMutableArray *valueConfigureArray; // <name, type> pair

// 获取表名
- (NSString*)tableName;

@end


@interface KFDatabaseService : NSObject

// 获取单体
+ (KFDatabaseService*)GetInstance;

// 切换到指定的操作数据库，当 dbName 为 nil 或 @""，将生成 default.sqilte，不调用则使用默认数据库
- (void)switchToDBWithDBName:(NSString*)dbName;

// 根据名称删除数据库
- (BOOL)removeDBWithDBName:(NSString*)dbName;

// 插入表项
// REPLACE INTO Table_adapter_1 (key_0, key_1, key_2, data, timestamp, etag) VALUES(?, ?, ?, ?, ?, ?), arguments需要依次填写入所有keys(主键), values(非主键)对应内容
- (BOOL)insertIntoTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments;

// 更新表项
// UPDATE Table_adapter_1 SET updateKey = updateValue WHERE key_0 = ? AND key_1 = ? AND key_2 = ?, arguments只能依次传入keys值，比如一共有(key_0, key_1, key_2), arguments可以是key_0, 或 (key_0, key_1), 或（key_0, key_1, key_2)
- (BOOL)updateTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments updateKey:(NSString*)updateKey updateValue:(id)updateValue;

// 选择表项
// SELECT * FROM Table_adapter_1 WHERE key_0 = ? AND key_1 = ? AND key_2 = ?, arguments只能依次传入keys值，比如一共有(key_0, key_1, key_2), arguments可以是key_0, 或 (key_0, key_1), 或（key_0, key_1, key_2), 返回的数据队列中为NSDictionary对象，包含返回数据项的集合
- (NSMutableArray*)selectFromTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments;

// 删除表项
- (BOOL)deleteFromTable:(id<KFDatabaseDelegate>)delegate arguments:(NSMutableArray*)arguments;

// 版本控制函数
//- (void)versionControl;

// 数据库版本升级
//- (void)upgrade;

// 根据传入字典参数更新表项
//- (BOOL)updateTable:(id<KFDatabaseDelegate>)delegate withDictArguments:(NSMutableDictionary*)arguments updateKey:(NSString*)updateKey updateValue:(id)updateValue;

// 根据传入字典参数选择表项
//- (NSMutableArray*)selectFromTable:(id<KFDatabaseDelegate>)delegate withDictArguments:(NSMutableDictionary*)arguments returnItems:(NSMutableArray*)returnItems;

// 根据传入字典参数删除表项
//- (BOOL)deleteFromTable:(id<KFDatabaseDelegate>)delegate withDictArguments:(NSMutableDictionary*)arguments;

@end