//
//  YCDatePickerView.h
//  view_test
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCDatePickerViewDelegate <NSObject>

- (void)YCDatePickerView_confirmed : (NSString *)dateStr;

@end

@interface YCDatePickerView : UIView

//代理
@property(nonatomic, strong)id<YCDatePickerViewDelegate> delegate;

//蒙层
@property(nonatomic, strong)UIView *grayView;

//选择器
@property(nonatomic, strong)UIDatePicker *datePicker;

//确定按钮
@property(nonatomic, strong)UIButton *confirmButton;

@end
