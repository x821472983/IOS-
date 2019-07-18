//
//  SelfInfoViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "SelfInfoViewController.h"
//视图
#import "SelfInfoCell.h"

@interface SelfInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSArray *dataArray;


@end

@implementation SelfInfoViewController

#pragma mark - [界面初始化]
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *name = [UserModel getInstance].name;
    NSString *sex = [UserModel getInstance].sex;
    NSString *birthday = [UserModel getInstance].birthday;
    NSString *card = [UserModel getInstance].card;
    NSString *phone = [UserModel getInstance].phone;
    NSString *communityName = [UserModel getInstance].communityName;
    NSString *unitName = [UserModel getInstance].unitName?:@"";
    
    
    _dataArray = @[
                   @[@"姓        名",name],
                   @[@"性        别",sex],
                   @[@"身  份  证",card],
                   @[@"出生日期",birthday],
                   @[@"手机号码",phone],
                   @[@"所属社区",communityName],
                   @[@"单位名称",unitName]
                   ];
    NSLog(@"%@", _dataArray);
    
    [_tableView registerNib:[UINib nibWithNibName:@"SelfInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - [表格相关]
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelfInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.left_label.text = [NSString stringWithFormat:@"%@:", _dataArray[indexPath.row][0]];
    cell.right_label.text = _dataArray[indexPath.row][1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - [杂乱]
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
