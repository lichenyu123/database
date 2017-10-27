//
//  LCYDBManager.h
//  dbTransition
//
//  Created by develop on 17/5/9.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FMDatabaseQueue.h"
#import "FMDB.h"
#import "testModel.h"
@interface LCYDBManager : NSObject
{
    FMDatabase *_testDatabase;
}
+(LCYDBManager *)shareInshance;

-(void)insertTestData:(testModel *)model;

-(void)updateTestData:(NSString *)modifyData;

-(void)deleteTestData:(NSString *)modifyData;

-(NSMutableArray *)selectedTestData:(NSString *)modifyData;

-(void)dropTable;

-(NSMutableArray *)searchDatalistFrom:(NSInteger)from limit:(NSInteger)limit;

-(NSString *)dbName;

-(void)deleteTable;
@end
