//
//  JXGTabBarViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "JXGTabBarViewController.h"

@interface JXGTabBarViewController ()
@property(nonatomic, strong)YCManager *manager;
@property(nonatomic, strong)NSUserDefaults *user;
@end

@implementation JXGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([UserModel getInstance].userId==NULL){
        //开启app时，进入登录界面
        [self performSelector:@selector(gotoLogin) withObject:nil afterDelay:0.5];
    }
   
}

//跳转登录页面
- (void)jumpLoginHome{
    [self.viewControllers[0] presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginHomeNavi"] animated:YES completion:^{
    }];
}


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


- (void)gotoLogin{
    //如果设置了自动登录
    if ([self.user boolForKey:@"自动登录"]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"登录中...";
        
        //发送账号和密码给后台接口
        [self.manager Guard_login_userName:[self.user objectForKey:@"账号"] password:[self.user objectForKey:@"密码"] successHandle:^(id data) {
            
            [hud hideAnimated:YES];
            
            //登录成功
            if ([data[@"message"] isEqual:@"登录成功"]) {
                [UIAlertTool showHUDToViewCenter:self.view message:data[@"message"]];
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

            }
            else{
                [UIAlertTool showHUDToViewTop:self.view message:data[@"message"]];
                [self jumpLoginHome];
            }
            
            
        } failureHandle:^(id error) {
            [hud hideAnimated:YES];
            NSLog(@"登录_失败: %@", error);
            [self jumpLoginHome];
        }];
    }
    else{
        [self jumpLoginHome];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
