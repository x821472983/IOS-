//
//  UIView+Common.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView(Common)

#pragma mark - [属性]
//设置获取x，y
@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;

//设置获取宽高
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;

#pragma mark - [行为]
///一行代码增加阴影，增加立体感
- (void)addShadow;

///一行代码移除阴影
- (void)removeShadow;

///一行代码增加虚线边框
- (void)addDottedBorder;

///一行代码移除虚线边框
- (void)removeDottedBorder;

///增加上边框
- (void)addTopBorder : (CGFloat)width;

///增加下边框
- (void)addBottomBorder : (CGFloat)width;

///可以为标签左侧添加一个小标示块(主要用于美化分类标题)
- (void)addLeftView;

///获取当前view的控制器对象
- (UIViewController *)getCurrentViewController;

@end
