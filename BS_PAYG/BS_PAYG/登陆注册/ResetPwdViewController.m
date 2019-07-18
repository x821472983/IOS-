//
//  ResetPwdViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "ResetPwdViewController.h"

@interface ResetPwdViewController ()
////<UITextFieldDelegate>
//网络
@property(nonatomic, strong)YCManager *manager;
@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    //设置文本代理
//    _PassWord.delegate = self;
//    _Password2.delegate = self;
}

#pragma mark - [键盘代理事件]
//键盘return收起键盘
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    return [textField resignFirstResponder];
//}

#pragma mark - [懒加载]
- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}

#pragma mark - [事件]
- (IBAction)ResetPwd:(UIButton *)sender {
      NSLog(@"重置密码成功");
    //[UIAlertTool showHUDToViewTop:self.view message:@"重置密码成功"];
    
    if(_PassWord.text.length<6){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入大于六位的新密码"];
        [_PassWord becomeFirstResponder];
        return;
    }
    else if(_PassWord.text!=_Password2.text){
          [UIAlertTool showHUDToViewTop:self.view message:@"请保持前后密码一致"];
        [_Password2 becomeFirstResponder];
        return;
    }
    
    //禁用按钮
    sender.enabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"重置中...";
    
    [self.manager Guard_updatePwd_userName:_name password:_PassWord.text successHandle:^(id data) {
        
        sender.enabled = YES;
        
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
        [UIAlertTool showHUDToViewCenter:self.view message:@"网络异常,请稍后重试"];
        NSLog(@"设置密码_失败: %@", error);
    }];
    
//    [UIAlertTool showHUDToViewTop:self.view message:@"重置密码成功"];
//        //返回到控制层跟页面
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}



@end
