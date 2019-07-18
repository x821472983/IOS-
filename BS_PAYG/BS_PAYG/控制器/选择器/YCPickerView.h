//
//  YCPickerView.h
//  view_test
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol YCPickerViewDelegate <NSObject>

- (void)YCPickerView_confirmed : (NSString *_Nonnull)info;

@end

@interface YCPickerView : UIView

@property(nonatomic, strong)id<YCPickerViewDelegate> _Nonnull delegate;

//更新数据
- (void)updateData : (NSArray *_Nullable)data;

//显示
- (void)show;

//向下隐藏
- (void)hideWithAnimate;

@end
