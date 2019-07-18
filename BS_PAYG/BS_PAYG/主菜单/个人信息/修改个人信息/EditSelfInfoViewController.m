//
//  EditSelfInfoViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "EditSelfInfoViewController.h"
//视图相关
#import "YCPickerView.h"
#import "YCDatePickerView.h"

#import "UIAlertTool.h"
//模型
#import "DeptModel.h"
#import "SQModel.h"

@interface EditSelfInfoViewController  ()<YCPickerViewDelegate, UITextFieldDelegate, YCDatePickerViewDelegate>{
    UIButton *currentBtn;//当前点击按钮
}

@property(nonatomic, strong)UIAlertTool *UIAlertTool;
//网络
@property(nonatomic, strong)YCManager *manager;
//选择器
@property(nonatomic, strong)YCPickerView *pickerView;
@property(nonatomic, strong)YCDatePickerView *datePickerView;//时间选择器
//模型
@property(nonatomic, strong)NSArray<DeptModel *> *deptModels;
@property(nonatomic, strong)NSArray<SQModel *> *sqModels;

@end

@implementation EditSelfInfoViewController

#pragma mark - [懒加载]
- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}
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
    [self layout];
   
}


- (void)layout{
    NSString *name = [UserModel getInstance].name;
    NSString *birthday = [UserModel getInstance].birthday;
    NSString *phone = [UserModel getInstance].phone;
    NSString *card = [UserModel getInstance].card?:@"";
    NSString *deptName = [UserModel getInstance].deptName;
    NSString *communityName = [UserModel getInstance].communityName;
    NSString *unitName = [UserModel getInstance].unitName?:@"";
    
    _name.text = name;
    [_birthday_button setTitle:birthday.length==0?@"请选择出生年月日":birthday forState:UIControlStateNormal];
    _phone.text = phone;
    _card.text = card;
    _unitName.text = unitName;
    [_police_button setTitle:deptName forState:UIControlStateNormal];
    [_community_button setTitle:communityName forState:UIControlStateNormal];
    
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

- (YCDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[YCDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

#pragma mark - [按钮文本赋值]
//将按钮的选择赋值到按钮的文本框上
- (void)YCDatePickerView_confirmed:(NSString *)dateStr{
    
    [_birthday_button setTitle:dateStr forState:UIControlStateNormal];
}
- (void)YCPickerView_confirmed : (NSString *_Nonnull)info{
    NSLog(@"%@", info);
    
    [currentBtn setTitle:info forState:UIControlStateNormal];
}

#pragma mark - [事件]
//点击注册
- (IBAction)Edit_Button:(UIButton *)sender {
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
    
    //选择派出所
    if([_police_button.titleLabel.text containsString:@"请选择"]){
        [UIAlertTool showHUDToViewTop:self.view message:@"请选择派出所"];
        [_police_button becomeFirstResponder];
        return;
    }
    
    //选择社区
    if([_community_button.titleLabel.text containsString:@"请选择"]){
        [UIAlertTool showHUDToViewTop:self.view message:@"请选择社区"];
        [_community_button becomeFirstResponder];
        return;
    }
    //禁用按钮
    sender.enabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"修改中...";
    
    [self.manager Guard_updateSysUserApp_name:_name.text birthday:_birthday_button.titleLabel.text phone:_phone.text card:_card.text deptName:_police_button.titleLabel.text  communityName:_community_button.titleLabel.text unitName:_unitName.text userId:[UserModel getInstance].userId successHandle:^(id data) {
        
        sender.enabled = YES;
        
        NSLog(@"%@", data);
        [hud hideAnimated:YES];
        
        //成功
        if ([data[@"message"] isEqual:@"修改成功"]) {
            
            //保存用户信息
            [[UserModel getInstance] setCard:self->_card.text];
            [[UserModel getInstance] setBirthday:self->_birthday_button.titleLabel.text];
            [[UserModel getInstance] setDeptName:self->_police_button.titleLabel.text];
            [[UserModel getInstance] setCommunityName:self->_community_button.titleLabel.text];
            [[UserModel getInstance] setUnitName:self->_unitName.text];
            [[UserModel getInstance] setPhone:self->_phone.text];
            
            [[UIAlertTool alloc] showAlertViewOn:self title:@"恭喜" message:@"修改成功" otherButtonTitle:@"确定" cancelButtonTitle:nil confirmHandle:^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
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
        NSLog(@"修改个人资料_失败: %@", error);
    }];
    
}

- (IBAction)Birthday:(UIButton *)sender {
    //显示时间选择器
    NSLog(@"出生日期");
    
    //弹出日期选择框
    [self.view addSubview:self.datePickerView];
    
    //取消并且隐藏其他元素框
    [_name resignFirstResponder];
    [_phone resignFirstResponder];
    [_card resignFirstResponder];
    [_unitName resignFirstResponder];
}

- (IBAction)PoliceClicked:(UIButton *)sender {
    NSLog(@"选择派出所");
    //如果已经显示，则隐藏
    if (_pickerView.frame.origin.y < SCREEN_HEIGHT && _pickerView.frame.origin.y != 0) {
        [_pickerView hideWithAnimate];
        return;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    //加载请求派出所信息
    for (int i = 0; i < self.deptModels.count; i++) {
        [dataArray addObject:_deptModels[i].deptName];
    }
//    for (int i = 0; i < 5; i++) {
//        NSString *res = [NSString stringWithFormat:@"派出所%d",i];
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

@end
