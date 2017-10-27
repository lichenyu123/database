//
//  ViewController.m
//  dbTransition
//
//  Created by develop on 17/5/9.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "ViewController.h"
#import "testModel.h"
#import "LCYDBManager.h"

@interface ViewController ()
{
    NSMutableArray *totalArr;
}

@property (nonatomic,strong)NSMutableArray *totalModelArr;
@end

@implementation ViewController

-(NSMutableArray *)totalModelArr
{
    if (!_totalModelArr)
    {
        _totalModelArr = [[NSMutableArray alloc]init];
    }
    
    return _totalModelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSDictionary *dict1 = @{@"name":@"侯亮平",@"age":@"43",@"score":@"100",@"sex":@"0"};
    
    NSDictionary *dict2 = @{@"name":@"林华华",@"age":@"33",@"score":@"80",@"sex":@"1"};
    
    NSDictionary *dict3 = @{@"name":@"李达康",@"age":@"53",@"score":@"90",@"sex":@"0"};
    
    NSDictionary *dict4 = @{@"name":@"高育良",@"age":@"63",@"score":@"90",@"sex":@"0"};
    
    NSDictionary *dict5 = @{@"name":@"小金子",@"age":@"60",@"score":@"100",@"sex":@"0"};
    
    totalArr = [NSMutableArray array];
    
    [totalArr addObject:dict1];
    
    [totalArr addObject:dict2];
    
    [totalArr addObject:dict3];
    
    [totalArr addObject:dict4];
    
    [totalArr addObject:dict5];
    
    NSLog(@"totalArr = %@",totalArr);
    
//    [[LCYDBManager shareInshance] dbName];
    
    self.totalModelArr = [[LCYDBManager shareInshance] selectedTestData:@""];
    
    NSLog(@"self.totalModelArr = %@ -- count = %lu",self.totalModelArr,self.totalModelArr.count);
}

- (IBAction)insertIntoTestModel:(id)sender
{
    for (NSDictionary *dict in totalArr)
    {
        testModel *model = [[testModel alloc] init];
        
        model.name = dict[@"name"];
        
        model.age = dict[@"age"];
        
        model.score = dict[@"score"];
        
        model.sex = dict[@"sex"];
        
        [[LCYDBManager shareInshance] insertTestData:model];
    }
}

- (IBAction)updateTestModel:(id)sender
{
    for (testModel *model in self.totalModelArr)
    {
        if ([model.name isEqualToString:@"小金子"])
        {
            [[LCYDBManager shareInshance] updateTestData:@"沙瑞金"];
        }
    }
}

- (IBAction)deleteTestModel:(id)sender
{
    [[LCYDBManager shareInshance] deleteTestData:@""];
}

- (IBAction)selectedTestModel:(id)sender
{
    if (self.totalModelArr.count > 0)
    {
        [self.totalModelArr removeAllObjects];
    }
    self.totalModelArr = [[LCYDBManager shareInshance] selectedTestData:@""];
}

- (IBAction)dropTableData:(id)sender
{
    [[LCYDBManager shareInshance] dropTable];
}

- (IBAction)orderByDescSearchData:(id)sender
{
    NSMutableArray *listArr = [[LCYDBManager shareInshance] searchDatalistFrom:0 limit:10];
    
    NSLog(@"listArr = %@",listArr);
}
- (IBAction)deleteTablesData:(id)sender
{
    [[LCYDBManager shareInshance] deleteTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
