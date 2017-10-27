//
//  LCYDBManager.m
//  dbTransition
//
//  Created by develop on 17/5/9.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "LCYDBManager.h"

@interface LCYDBManager()

@end

@implementation LCYDBManager

static LCYDBManager * instance = nil;
+(LCYDBManager *)shareInshance
{
    static dispatch_once_t once;
    
    
    
    dispatch_once(&once, ^{
       
        if (instance == nil)
        {
            instance = [[[self class] alloc] init];
        }
        
    });
    
    return instance;
}

-(FMDatabase *)testDataDB
{
    if (!_testDatabase)
    {
        //把创建好的数据库复制到指定路径下
//        [self copyPathToDesPath];
        
        NSString *dbPath = [self dbName];
        NSLog(@"dbPath = %@",dbPath);
        
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        
        if ([db open])
        {
            BOOL result = [db executeUpdate:@"create table if not exists student (ID text not null, name text not null,age text not null,score text not null,sex text not null);"];

            if (result)
            {
                NSLog(@"建表成功");
            }
            else
            {
                NSLog(@"建表失败");
            }
        }
       
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            _testDatabase = db;
            
            if (![_testDatabase open])
            {
                NSLog(@"Could not open database!");
            }
            
            [_testDatabase setLogsErrors:YES];
            
        }];
    }

    return _testDatabase;
}

-(NSString *)dbName
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dbName = [filePath stringByAppendingPathComponent:@"test.db"];
    
    return dbName;
}

-(NSString *)createTableName:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM sqlite_master WHERE name = '%@' and type = 'table'",tableName];
    
    FMResultSet *rs = [[self testDataDB] executeQuery:sql,nil];
    
    NSString *str = nil;
    
    while ([rs next])
    {
        str = [rs stringForColumn:@"sql"];
    }
    return str;
}

-(void)copyPathToDesPath
{
    NSString *oPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"test.db"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *desPath = [self dbName];
    
    NSString *folderPath = [desPath stringByReplacingOccurrencesOfString:@"/test.db" withString:@""];
    
    if (![fileManager fileExistsAtPath:folderPath])
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fileManager fileExistsAtPath:desPath])
    {
        [fileManager copyItemAtPath:oPath toPath:desPath error:nil];
    }
}

-(void)insertTestData:(testModel *)model
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO student (%@,%@,%@,%@,%@) VALUES (?,?,?,?,?)",@"ID",@"name",@"age",@"score",@"sex"];

    [[self testDataDB] executeUpdate:sql,[self ret32bitString],model.name,model.age,model.score,model.sex,nil];
}

- (NSString *)ret32bitString
{
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

-(void)updateTestData:(NSString *)modifyData
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE student SET name='%@' where name='小金子'",modifyData];
    
    [[self testDataDB]executeUpdate:sql,nil];
}

-(NSMutableArray *)selectedTestData:(NSString *)modifyData
{
    NSMutableArray *testListArr = [[NSMutableArray alloc]init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from student"];
    
    FMResultSet *rs = [[self testDataDB] executeQuery:sql,nil];
    
    while ([rs next])
    {
        testModel *model = [[testModel alloc]init];
        
        model.name = [rs stringForColumn:@"name"];
        
        model.age = [rs stringForColumn:@"age"];
        
        model.score = [rs stringForColumn:@"score"];
        
        model.sex = [rs stringForColumn:@"sex"];
        
        [testListArr addObject:model];
    }
    return testListArr;
}

-(void)deleteTestData:(NSString *)modifyData
{
    NSString *sql = [NSString stringWithFormat:@"delete from student where name = '沙瑞金'"];
    
    [[self testDataDB] executeUpdate:sql,nil];
}

-(void)dropTable
{
//    NSString *sql = [NSString stringWithFormat:@"drop table if exist testtable"];
    //用下面sql语句也行
    NSString *sql = [NSString stringWithFormat:@"drop table student"];
    
    [[self testDataDB] executeUpdate:sql,nil];
}

-(NSMutableArray *)searchDatalistFrom:(NSInteger)from limit:(NSInteger)limit
{
    NSMutableArray *listArr = [[NSMutableArray alloc]init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from student order by age desc limit %ld,%ld",from,limit];
    FMResultSet *rs = [[self testDataDB] executeQuery:sql,nil];

    while ([rs next])
    {
        testModel *model = [[testModel alloc]init];
        
        model.name = [rs stringForColumn:@"name"];
        
        model.age = [rs stringForColumn:@"age"];
        
        model.score = [rs stringForColumn:@"score"];
        
        model.sex = [rs stringForColumn:@"sex"];
        
        [listArr addObject:model];
    }
    
    return listArr;
}

//只是删除表中的数据
-(void)deleteTable
{
    NSString *sql = [NSString stringWithFormat:@"delete from student"];
    [[self testDataDB] executeUpdate:sql,nil];
}
@end
