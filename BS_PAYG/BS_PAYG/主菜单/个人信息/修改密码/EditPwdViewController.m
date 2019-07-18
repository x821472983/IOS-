//
//  EditPwdViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "EditPwdViewController.h"

@interface EditPwdViewController ()
//网络
@property(nonatomic, strong)YCManager *manager;
@end

@implementation EditPwdViewController

#pragma mark - [懒加载]
- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)Reset_Pwd:(UIButton *)sender {
    if(_Old_Pwd.text.length==0){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入旧密码"];
        [_Old_Pwd becomeFirstResponder];
        return;
    }
    else if(_New_Pwd.text.length<6){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入大于六位的新密码"];
        [_New_Pwd becomeFirstResponder];
        return;
    }
    else if(_New_Pwd2.text!=_New_Pwd.text){
        [UIAlertTool showHUDToViewTop:self.view message:@"请保持前后密码一致"];
        [_New_Pwd2 becomeFirstResponder];
        return;
    }
    
    
    //禁用按钮
    sender.enabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"重置中...";
    
    [self.manager Guard_updatePwd_userId:[UserModel getInstance].userId oldPassword:_Old_Pwd.text  newPassword:_New_Pwd.text successHandle:^(id data) {
        
        sender.enabled = YES;
        [hud hideAnimated:YES];
        NSLog(@"%@", data);
        
        //成功
        if ([data[@"message"] isEqual:@"修改成功"]) {
            [[UIAlertTool alloc] showAlertViewOn:self title:@"" message:data[@"message"] otherButtonTitle:@"确定" cancelButtonTitle:nil confirmHandle:^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } cancleHandle:^{
            }];
        }
        else{
            [UIAlertTool showHUDToViewTop:self.view message:data[@"message"]];
        }
        
        
    } failureHandle:^(id error) {
        sender.enabled = YES;
        [hud hideAnimated:YES];
        [UIAlertTool showHUDToViewCenter:self.view message:@"网络异常,请稍后重试"];
        NSLog(@"设置密码_失败: %@", error);
    }];
    
        [UIAlertTool showHUDToViewTop:self.view message:@"重置密码成功"];
}

@end
