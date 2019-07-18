//
//  UIView+Common.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//


#import "UIView+Common.h"

@implementation UIView(Common)

#pragma mark - [属性]
//x
- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

//y
- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

//宽度
- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width{
    return self.frame.size.width;
}

//高度
- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height{
    return self.frame.size.height;
}

#pragma mark - [行为]
///一行代码增加阴影
- (void)addShadow{
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 1);
    self.layer.shadowOpacity = 1;
}

///一行代码移除阴影
- (void)removeShadow{
    self.layer.shadowColor = nil;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0;
    self.layer.borderColor = nil;
    self.layer.borderWidth = 0;
}

///一行代码增加虚线边框
- (void)addDottedBorder{
    
    //已经有了就不添加了
    if (self.layer.sublayers.count>=2) {
        return;
    }
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    border.lineWidth = 1.5f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@6, @6];
    [self.layer addSublayer:border];
}

///一行代码移除虚线边框
- (void)removeDottedBorder{
    if (self.layer.sublayers.count>=2) {
        [self.layer.sublayers[1] removeFromSuperlayer];
    }
}

///增加上边框
- (void)addTopBorder : (CGFloat)width{
    CALayer *topLine = [[CALayer alloc]init];
    topLine.frame = CGRectMake(0, 0, self.width, width);
    topLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:topLine];
}

///增加下边框
- (void)addBottomBorder : (CGFloat)width{
    CALayer *bottomLine = [[CALayer alloc]init];
    bottomLine.frame = CGRectMake(0, self.height-width, self.width, width);
    bottomLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:bottomLine];
}

///可以为标签左侧添加一个小标示块(主要用于美化分类标题)
- (void)addLeftView{
    //标题左侧美观的view
    CALayer *leftView = [[CALayer alloc]init];
    leftView.frame = CGRectMake(-8, 9, 5, 12);
    [self.layer addSublayer:leftView];
}

///获取当前view的控制器对象
- (UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


@end
