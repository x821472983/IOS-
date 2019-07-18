//
//  YCPickerView.m
//  view_test
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "YCPickerView.h"

@interface YCPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>{
    //记录选中哪个
    int column0;
}

//数据源
@property(nonatomic, strong)NSArray *data;

//显示结果的标签
@property(nonatomic, strong)UILabel *resultLabel;

//选择器
@property(nonatomic, strong)UIPickerView *pickerView;

//蒙层
@property(nonatomic, strong)UIView *grayView;

//底层
@property(nonatomic, strong)UIView *bottomView;

@end

@implementation YCPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        //默认选择第一个
        column0 = 0;
        [self layout];
    }
    return self;
}

//界面布局
- (void)layout{
    
    //蒙层
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    [_grayView addGestureRecognizer:tapGesture];
    [self addSubview:_grayView];
    
    //底层
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
    _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _bottomView.layer.borderColor = JXG_COLOR.CGColor;
    _bottomView.layer.borderWidth = 1;
    [self addSubview:_bottomView];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = JXG_COLOR.CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 5;
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cancelBtn];
    //选择弹出框样式规定
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(30);
    }];
    
    //结果显示Label
    _resultLabel = [[UILabel alloc]init];
    _resultLabel.font = [UIFont systemFontOfSize:15];
    _resultLabel.text = @"";
    _resultLabel.textColor = JXG_COLOR;
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_resultLabel];
    //选择弹出框样式规定
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    //确定按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = JXG_COLOR;
    confirmBtn.layer.borderColor = JXG_COLOR.CGColor;
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.cornerRadius = 5;
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    //选择弹出框样式规定
    [_bottomView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(30);
    }];
    
    //分隔线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = JXG_COLOR;
    [_bottomView addSubview:lineView];
    //选择弹出框样式规定
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 160)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_bottomView addSubview:_pickerView];
}

- (void)hide:(UITapGestureRecognizer *)gesture{
    [self hideWithAnimate];
}

//关闭视图
- (void)cancel : (UIButton *)button{
    [self hideWithAnimate];
}

//确定按钮
- (void)confirm : (UIButton *)button{
    
    if (_data.count > 0) {
        //触发代理
        if ([self.delegate respondsToSelector:@selector(YCPickerView_confirmed:)]) {
            [self.delegate YCPickerView_confirmed:_data[column0]];
        }
        
        [self hideWithAnimate];
    }
}

#pragma mark - [pickerView相关]
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return _data.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
        pickerLabel.textColor = JXG_COLOR;
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return _data[row];
            break;
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            column0 = (int)row;
            break;
        default:
            break;
    }
}

//更新数据
- (void)updateData : (NSArray *_Nullable)data{
    
    column0 = 0;
    
    _data = [NSArray arrayWithArray:data];
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:0 inComponent:0 animated:YES];
}

- (void)show{
    
    self.hidden = NO;
    
    //布局
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.superview).offset(200);
        make.left.equalTo(self.bottomView.superview);
        make.right.equalTo(self.bottomView.superview);
        make.height.mas_equalTo(200);
    }];
    //如果其约束还没有生成的时候需要动画的话，就请先强制刷新后才写动画，否则所有没生成的约束会直接跑动画
    [self.bottomView.superview layoutIfNeeded];
    
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.superview).offset(0);
        }];
        //强制绘制
        [self.bottomView.superview layoutIfNeeded];
    }];
}

//向下隐藏
- (void)hideWithAnimate{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.superview).offset(200);
        }];
        [self.bottomView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];
}

@end
