//
//  RegisterViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "RegisterViewController.h"
//视图相关
#import "YCPickerView.h"
#import "YCDatePickerView.h"

#import "UIAlertTool.h"
//模型
#import "DeptModel.h"
#import "SQModel.h"

@interface RegisterViewController ()<YCPickerViewDelegate, UITextFieldDelegate, YCDatePickerViewDelegate>{
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




@implementation RegisterViewController

//键盘return收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark - [页面加载]
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

#pragma mark - [懒加载]
//网络
- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}

//派出所、社区选择器加载
- (YCPickerView *)pickerView{
    if(!_pickerView){
        _pickerView = [[YCPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}
//事件选择器加载
- (YCDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[YCDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

#pragma mark - [按钮文本赋值]
//时间选择器按钮文本框赋值
- (void)YCDatePickerView_confirmed:(NSString *)dateStr{
    
    [_birthday setTitle:dateStr forState:UIControlStateNormal];
}

//当前选择按钮文本框赋值
- (void)YCPickerView_confirmed : (NSString *_Nonnull)info{
    NSLog(@"%@", info);
    
    [currentBtn setTitle:info forState:UIControlStateNormal];
}

#pragma mark - [事件]
//点击注册
- (IBAction)Register:(UIButton *)sender {
    //姓名识别
    if(_name.text.length==0){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入姓名"];
        [_name becomeFirstResponder];
        return;
    }
    //性别识别
    NSString *sex = @"2";//2为未选择  0男，1女
    if (_man_button.isSelected) {
        sex = @"0";
    }
    else if (_woman_button.isSelected){
        sex = @"1";
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
    
    //密码校正
    if(_password.text.length==0){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入密码"];
        [_password becomeFirstResponder];
        return;
    }
    else if(_password.text.length<6){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入大于六位的密码"];
        [_password becomeFirstResponder];
        return;
    }
    
    //确认密码
    if(_superPassword.text!=_password.text){
        [UIAlertTool showHUDToViewTop:self.view message:@"请输入两个相同的密码"];
        [_superPassword becomeFirstResponder];
        return;
    }
    //选择派出所
    if([_policeClicked.titleLabel.text containsString:@"请选择"]){
        [UIAlertTool showHUDToViewTop:self.view message:@"请选择派出所"];
        [_policeClicked becomeFirstResponder];
        return;
    }
    //选择社区
    if([_communityClicked.titleLabel.text containsString:@"请选择"]){
        [UIAlertTool showHUDToViewTop:self.view message:@"请选择社区"];
        [_communityClicked becomeFirstResponder];
        return;
    }
    
    sender.enabled = NO;//禁用按钮
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"注册中...";
    
    
    [self.manager Guard_register_name: (NSString *)_name.text password : (NSString *)_password.text birthday : (NSString *)_birthday.titleLabel.text sex : (NSString *)sex phone : (NSString *)_phone.text card : (NSString *)_card.text  deptName : (NSString *)_policeClicked.titleLabel.text unitName : (NSString *)_unitName.text communityName : (NSString *)_communityClicked.titleLabel.text successHandle:^(id data) {
        
        sender.enabled = YES;
        
        NSLog(@"%@", data);
        [hud hideAnimated:YES];
        
        //成功
        if ([data[@"message"] isEqual:@"注册成功"]) {
            [[UIAlertTool alloc] showAlertViewOn:self title:@"恭喜" message:@"注册成功" otherButtonTitle:@"确定" cancelButtonTitle:nil confirmHandle:^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } cancleHandle:^{
            }];
        }
        else{
            [UIAlertTool showHUDToViewTop:self.view message:data[@""]];
        }
        
        
    } failureHandle:^(id error) {
        sender.enabled = YES;
        [hud hideAnimated:YES];
        [UIAlertTool showHUDToViewTop:self.view message:@"注册失败，请检查网络后重试"];
        NSLog(@"注册_失败: %@", error);
    }];
    
//    NSLog(@"注册成功");
//     [UIAlertTool showHUDToViewTop:self.view message:@"注册成功"];
//    //控制层去掉第一层的页面，返回到第二层
//    [self.navigationController popViewControllerAnimated:YES];
   
}


- (IBAction)Man:(UIButton *)sender {
    NSLog(@"选择男性");
    
    _woman_button.selected = NO;
    _man_button.selected = YES;
}
- (IBAction)Women:(UIButton *)sender {
    NSLog(@"选择女性");
    _woman_button.selected = YES;
    _man_button.selected = NO;
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
    [_password resignFirstResponder];
    [_superPassword resignFirstResponder];
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

//        for (int i = 0; i < 5; i++) {
//            NSString *res = [NSString stringWithFormat:@"派出所%d",i];
//            [dataArray addObject:res];
//        }
    
    currentBtn = sender;
    
    //派出所选择框赋值
    [self.pickerView updateData:dataArray];
    
     //取消并且隐藏其他元素框
    [_name resignFirstResponder];
    [_phone resignFirstResponder];
    [_card resignFirstResponder];
    [_password resignFirstResponder];
    [_superPassword resignFirstResponder];
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
    [_password resignFirstResponder];
    [_superPassword resignFirstResponder];
    [_unitName resignFirstResponder];
    
    //弹出社区选择框
    [self.pickerView show];
}

#pragma mark - [textField代理]
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_pickerView hideWithAnimate];
}





@end
