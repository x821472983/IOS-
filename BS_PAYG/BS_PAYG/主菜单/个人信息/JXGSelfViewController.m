//
//  JXGSelfViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "JXGSelfViewController.h"

@interface JXGSelfViewController ()<UITableViewDelegate, UITableViewDataSource>

//标题
@property(nonatomic, strong)NSArray *titleArray;

@end

@implementation JXGSelfViewController

#pragma mark - [界面初始化]
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示导航栏背景
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //获取最新个人信息
//    [self.manager Guard_findSysDeptMyself_userId:[UserModel getInstance].userId successHandle:^(id data) {
//
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//
//        //保存用户信息
//        [[UserModel getInstance] setDic:data[@"data"][0]];
        _name_label.text = [UserModel getInstance].name;
        NSString *test = [UserModel getInstance].intergral;
        _score_label.text = [NSString stringWithFormat:@"积分: %@分",test];
//
        float newWidth = [_score_label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, _score_label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width+10;
        [_score_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(newWidth);
        }];
//
//    } failureHandle:^(id error) {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        [UIAlertTool showHUDToViewCenter:self.view message:@"网络异常,请稍后重试"];
//        NSLog(@"个人信息查询_失败: %@", error);
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[
                    @"查看个人信息",
                    @"编辑个人信息",
                    @"修改密码",
                    @"版本号"
                    //                    @"帮助"
                    ];
    
    [self layout];
    //    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc]init];
}

- (void)layout{
    //[_topView addShadow];
    _head_imageView.layer.cornerRadius = _head_imageView.frame.size.width/2;
    _head_imageView.layer.borderWidth = 2;
    _head_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _score_label.layer.cornerRadius = 10.5;
    _score_label.layer.masksToBounds = YES;
    float newWidth = _score_label.frame.size.width+10;
    [_score_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(newWidth);
    }];
}

#pragma mark - [懒加载]


#pragma mark - [事件]
//登出
- (void)logout:(UIButton *)sender{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginHomeNavi"] animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"自动登录"];
    }];
}

#pragma mark - [表格相关]
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"self%ld", indexPath.row]];
    
    cell.textLabel.text = _titleArray[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //版本号的情况
    if ([_titleArray[indexPath.row] isEqualToString:@"版本号"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//添加表单
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加退出按钮表单单元格
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    quitBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:10/255.0 blue:10/255.0 alpha:0.9];
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    quitBtn.layer.cornerRadius = 5;
    [quitBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:quitBtn];
    
    //手动设置退出按钮样式
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(20);
        make.right.equalTo(footView).offset(-20);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(footView);
    }];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

//cell表格点击跳转事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@", _titleArray[indexPath.row]);
    
    if ([_titleArray[indexPath.row] isEqualToString:@"查看个人信息"]) {
        [self performSegueWithIdentifier:@"ckgrxx" sender:nil];
    }
    else if ([_titleArray[indexPath.row] isEqualToString:@"编辑个人信息"]) {
        [self performSegueWithIdentifier:@"bjgrxx" sender:nil];
    }
    else if ([_titleArray[indexPath.row] isEqualToString:@"修改密码"]) {
        [self performSegueWithIdentifier:@"xgmm" sender:nil];
    }
}

#pragma mark - [杂乱]
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
