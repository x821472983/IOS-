//
//  ForgetPwdViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "ForgetPwdViewController.h"
//视图相关
#import "YCPickerView.h"

#import "UIAlertTool.h"
#import "ResetPwdViewController.h"
//模型
#import "DeptModel.h"
#import "SQModel.h"
@interface ForgetPwdViewController ()<YCPickerViewDelegate, UITextFieldDelegate>{
    UIButton *currentBtn;//当前点击按钮
}

@property(nonatomic, strong)UIAlertTool *UIAlertTool;
//网络
@property(nonatomic, strong)YCManager *manager;
//选择器
@property(nonatomic, strong)YCPickerView *pickerView;
//模型
@property(nonatomic, strong)NSArray<DeptModel *> *deptModels;
@property(nonatomic, strong)NSArray<SQModel *> *sqModels;
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"数据读取中...";
    
    __block int count = 0;
    
    //请求公安局数据
    [self.manager selectDept_successHandle:^(id data) {
        if([data[@"result"] isEqualToNumber:@0]){
            //转模型
            self->_deptModels = [DeptModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            count++;
            if (count == 2) {
                [hud hideAnimated:YES];
            }
        }else{
            [hud hideAnimated:YES];
            [UIAlertTool showHUDToViewCenter:self.view message:data[@"message"]];
        }
        
        
    } failureHandle:^(id error) {
        [hud hideAnimated:YES];
        [UIAlertTool showHUDToViewCenter:self.view message:@"派出所数据获取失败，请稍后重试"];
        NSLog(@"公安局数据_失败: %@", error);
    }];
    
    //请求社区数据
    [self.manager selectCommunity_successHandle:^(id data) {
        NSLog(@"%@",data);
        if([data[@"result"] isEqualToNumber:@0]){
            NSLog(@"%@",data);
            //转模型
            self->_sqModels = [SQModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            count++;
            if (count == 2) {
                [hud hideAnimated:YES];
            }
        }else{
            [hud hideAnimated:YES];
            [UIAlertTool showHUDToViewCenter:self.view message:data[@"message"]];
        }
    } failureHandle:^(id error) {
        [hud hideAnimated:YES];
        [UIAlertTool showHUDToViewCenter:self.view message:@"社区数据获取失败，请稍后重试"];
        NSLog(@"社区数据_失败: %@", error);
    }];
    
    // Do any additional setup after loading the view.
}
#pragma mark - [键盘代理事件]
//键盘return收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark - [懒加载]
- (YCPickerView *)pickerView{
    if(!_pickerView){
        _pickerView = [[YCPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}

- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}
#pragma mark - [按钮文本赋值]
//将按钮的选择赋值到按钮的文本框上
- (void)YCPickerView_confirmed : (NSString *_Nonnull)info{
    NSLog(@"%@", info);
    
    [currentBtn setTitle:info forState:UIControlStateNormal];
}

#pragma mark - [事件]
//点击重置
- (IBAction)Reset_Button:(UIButton *)sender {
    //姓名识别
    if(_name.text.length==0){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入姓名"];
        [_name becomeFirstResponder];
        return;
    }
    
    //手机号校正字符
    NSString *regularStr = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    
    //如果手机号码不等于11位或者格式不正确
    if (![predicate evaluateWithObject:_phone.text]) {
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入正确的手机号"];
        [_phone becomeFirstResponder];
        return;
    }
    
    //身份证校正字符
    regularStr = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|x|X)$";
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    
    //如果身份证号码长度大于0并且格式不正确
    if(_card.text.length > 0 && ![predicate2 evaluateWithObject:_card.text])
    {
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入正确的身份证号码"];
        [_card becomeFirstResponder];
        return;
    }
    
    if([_policeClicked.titleLabel.text containsString:@"请选择"]){
        [UIAlertTool showHUDToViewTop:self.view message:@"请选择派出所"];
        [_policeClicked becomeFirstResponder];
        return;
    }
    if([_communityClicked.titleLabel.text containsString:@"请选择"]){
        [UIAlertTool showHUDToViewTop:self.view message:@"请选择社区"];
        [_communityClicked becomeFirstResponder];
        return;
    }
    
    //禁用按钮
    sender.enabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"核查中...";
    

    [self.manager Guard_CheckUserData_name : (NSString *)_name.text phone : (NSString *)_phone.text card : (NSString *)_card.text deptName : (NSString *)_policeClicked.titleLabel.text unitName : (NSString *)_unitName.text communityName : (NSString *)_communityClicked.titleLabel.text successHandle:^(id data) {
        
        sender.enabled = YES;
        
        NSLog(@"%@", data);
        [hud hideAnimated:YES];
        //成功
        if ([data[@"message"] isEqual:@"审核成功"]) {
            [[UIAlertTool alloc] showAlertViewOn:self title:@"" message:@"审核成功" otherButtonTitle:@"确定" cancelButtonTitle:nil confirmHandle:^{
                 NSLog(@"信息确认成功");
                [self performSegueWithIdentifier:@"goNext" sender:nil];
                
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
        NSLog(@"重置密码_失败: %@", error);
    }];
   
//    [UIAlertTool showHUDToViewTop:self.view message:@"信息确认成功"];
//    //控制层执行ID为goNext的链接
//     [self performSegueWithIdentifier:@"goNext" sender:nil];
    
}

- (IBAction)PoliceClicked:(UIButton *)sender {
    NSLog(@"选择派出所");
    //如果已经显示，则隐藏
    if (_pickerView.frame.origin.y < SCREEN_HEIGHT && _pickerView.frame.origin.y != 0) {
        [_pickerView hideWithAnimate];
        return;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
//    加载请求派出所信息
        for (int i = 0; i < self.deptModels.count; i++) {
            [dataArray addObject:_deptModels[i].deptName];
        }
    
//    for (int i = 0; i < 5; i++) {
//        NSString *res = [NSString stringWithFormat:@"嘉兴派出所%d",i];
//        [dataArray addObject:res];
//    }
    
    currentBtn = sender;
    
    //派出所选择框赋值
    [self.pickerView updateData:dataArray];
    
    //取消并且隐藏其他元素框
    [_name resignFirstResponder];
    [_phone resignFirstResponder];
    [_card resignFirstResponder];
    [_unitName resignFirstResponder];
    
    //弹出派出所选择框
    [self.pickerView show];
}

- (IBAction)communityClicked:(UIButton *)sender {
    NSLog(@"选择社区");
    //如果已经显示，则隐藏
    if (_pickerView.frame.origin.y < SCREEN_HEIGHT && _pickerView.frame.origin.y != 0) {
        [_pickerView hideWithAnimate];
        return;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    //加载请求社区信息
        for (int i = 0; i < _sqModels.count; i++) {
            [dataArray addObject:_sqModels[i].communityName];
        }
    
//    for (int i = 0; i < 5; i++) {
//        NSString *res = [NSString stringWithFormat:@"社区%d",i];
//        [dataArray addObject:res];
//    }
    
    currentBtn = sender;
    
    //社区选择框赋值
    [self.pickerView updateData:dataArray];
    
    //取消并且隐藏其他元素框
    [_name resignFirstResponder];
    [_phone resignFirstResponder];
    [_card resignFirstResponder];
    [_unitName resignFirstResponder];
    
    //弹出社区选择框
    [self.pickerView show];
}

#pragma mark - [页面传值]
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goNext"]) {
        UIViewController *vc = segue.destinationViewController;
        if ([vc respondsToSelector:@selector(setName:)]) {
            [vc setValue:_name.text forKey:@"name"];
        }
    }
}
@end
