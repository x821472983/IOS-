//
//  LoginViewController.m
//  view_testTests
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)YCManager *manager;
//用户手机上储存的信息
@property(nonatomic, strong)NSUserDefaults *user;
@property(nonatomic, strong)UIAlertTool *UIAlertTool;

@end

@implementation LoginViewController

- (void)layout{
    [_account_textField setLeftViewWithTitle:@"手机号码"];
    [_password_textField setLeftViewWithTitle:@"密码"];
    
    _LoginButton.layer.cornerRadius = 5;
}

#pragma mark - [懒加载]
- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}

- (NSUserDefaults *)user{
    if (!_user) {
        _user = [NSUserDefaults standardUserDefaults];
    }
    return _user;
}
#pragma mark - [界面初始化]
//当收到视图在视窗将可见时的通知会呼叫的方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

//当收到视图将去除、被覆盖或隐藏于视窗时的通知会呼叫的方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示导航栏背景
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

//点击return收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

//页面初始化必要函数
- (void)viewDidLoad{
    [super viewDidLoad];
     [self layout];
    //设置文本代理
    _password_textField.delegate = self;
    _account_textField.delegate = self;
}


//登陆成功跳转
- (void) success{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"] animated:YES completion:^{
    }];
}


#pragma mark - [事件]
//登陆按钮触发事件
- (IBAction)LoginButton:(UIButton *)sender {
    
    self.UIAlertTool=[[UIAlertTool alloc] init];
    if(_account_textField.text.length!=11){
        [UIAlertTool showHUDToViewCenter:self.view message:@"请输入正确的手机号"];
        [_account_textField becomeFirstResponder];
        return;
    }
    else if(_password_textField.text.length<6){
        [UIAlertTool showHUDToViewCenter:self.view message:@"请输入正确的密码"];
        [_password_textField becomeFirstResponder];
        return;
    }
    
    sender.enabled = NO;//禁用按钮
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"登录中...";
    
    [self.manager Guard_login_userName:_account_textField.text password:_password_textField.text successHandle:^(id data) {
        
        [hud hideAnimated:YES];
        
        //登录成功
        if ([data[@"message"] isEqual:@"登录成功"]) {
            [UIAlertTool showHUDToViewCenter:self.view message:data[@"message"]];
            
            //记录是否是记住密码
            if (self->_RemenberPassword.isSelected) {
                [self.user setObject:self->_account_textField.text forKey:@"账号"];
                [self.user setObject:self->_password_textField.text forKey:@"密码"];
                [self.user setBool:YES forKey:@"记住密码"];
            }
            else{
                [self.user setObject:@"" forKey:@"账号"];
                [self.user setObject:@"" forKey:@"密码"];
                [self.user setBool:NO forKey:@"记住密码"];
            }
            //记录是否是自动登录
            if (self->_AutoLogin.isSelected) {
                [self.user setObject:self->_account_textField.text forKey:@"账号"];
                [self.user setObject:self->_password_textField.text forKey:@"密码"];
                [self.user setBool:YES forKey:@"自动登录"];
            }
            else{
                [self.user setBool:NO forKey:@"自动登录"];
            }
            NSString * sex = data[@"sex"]==0? @"男":@"女";
            //保存用户信息
            [[UserModel getInstance] setUserId:data[@"userId"]];
            [[UserModel getInstance] setName:data[@"name"]];
            [[UserModel getInstance] setSex:sex];
            [[UserModel getInstance] setCard:data[@"card"]];
            [[UserModel getInstance] setBirthday:data[@"birthday"]];
            [[UserModel getInstance] setDeptName:data[@"deptName"]];
            [[UserModel getInstance] setCommunityName:data[@"communityName"]];
            [[UserModel getInstance] setUnitName:data[@"unitName"]];
            [[UserModel getInstance] setPhone:data[@"phone"]];
            [[UserModel getInstance] setIntergral:data[@"intergral"]];
            
            [self success];
        }
        else{
            [UIAlertTool showHUDToViewTop:self.view message:data[@"message"]];
        }
        
        sender.enabled = YES;
        
    } failureHandle:^(id error) {
        
        [hud hideAnimated:YES];
        
        sender.enabled = YES;
        
        [UIAlertTool showHUDToViewCenter:self.view message:@"网络异常,请稍后重试"];
        
        NSLog(@"登录_失败: %@", error);
        
    }];
}

- (IBAction)RemenberPassword:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        [self.user setObject:@"" forKey:@"账号"];
        [self.user setObject:@"" forKey:@"密码"];
    }
    else{
        sender.selected = YES;
        [self.user setObject:_account_textField.text forKey:@"账号"];
        [self.user setObject:_password_textField.text forKey:@"密码"];
    }
}
- (IBAction)AutoLogin:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }
    else{
        sender.selected = YES;
    }
}


@end
