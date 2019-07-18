//
//  YCDatePickerView.m
//  view_test
//
//  Created by 梁志华 on 2019/2/27.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "YCDatePickerView.h"

@implementation YCDatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout{
    //蒙层
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    [_grayView addGestureRecognizer:tapGesture];
    [self addSubview:_grayView];
    
    //选择器
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-265, SCREEN_WIDTH, 200)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.maximumDate = [NSDate new];//最大只能当天
    [self addSubview:_datePicker];
    
    //确定按钮
    _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:JXG_COLOR];
    [_confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_datePicker.mas_bottom).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
}

- (void)hide:(UITapGestureRecognizer *)gesture{
    [self removeFromSuperview];
}

- (void)confirm:(UIButton *)sender{
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy-MM-dd"];
//    NSLog(@"%@", [format stringFromDate:_datePicker.date]);
    
    if ([self.delegate respondsToSelector:@selector(YCDatePickerView_confirmed:)]) {
        [self.delegate YCDatePickerView_confirmed:[format stringFromDate:_datePicker.date]];
    }
    
    [self removeFromSuperview];
}

@end
