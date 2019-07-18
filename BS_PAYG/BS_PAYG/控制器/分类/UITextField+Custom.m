//
//  UITextField+Custom.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//


#import "UITextField+Custom.h"

@implementation UITextField (Custom)

-(void)drawRect:(CGRect)rect
{
    //如果是无边框的设置0.5个像素的边框
    if (self.borderStyle == UITextBorderStyleLine) {
        
        self.layer.borderWidth = 0.3f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}


- (void)setLeftViewWithTitle:(NSString *)title
{
    
    //    self.height = 50;
    UIView *leftView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, self.height)];
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, leftView.width-10, self.height)];
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    [label setTextColor:[UIColor grayColor]];
    
    UIView *rightLine= [[UIView alloc]initWithFrame:CGRectMake(leftView.width-2, 10, 1, self.height-20)];
    rightLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [leftView addSubview:label];
    [leftView addSubview:rightLine];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
}

- (void)setLeftViewWithImage:(NSString *)imageName
{
    UIView *leftView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.height+5, self.height)];
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.height = leftView.height-10;
    imageView.frame = CGRectMake(7, 7, self.height-14, self.height-14);
    //    imageView.top = 0;
    UIView *rightLine= [[UIView alloc]initWithFrame:CGRectMake(leftView.width-5, 10, 1, self.height-20)];
    rightLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [leftView addSubview:imageView];
    [leftView addSubview:rightLine];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
}
- (void)setLeftViewWithImage:(NSString *)imageName AndWithTitle:(NSString *)title
{
    UIView *leftView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.height + 70, self.height)];
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.height = leftView.height-10;
    imageView.frame = CGRectMake(7, 7, self.height-14, self.height-14);
    //    imageView.top = 0;
    
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 70, self.height)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor grayColor]];
    UIView *rightLine= [[UIView alloc]initWithFrame:CGRectMake(leftView.width-2, 10, 1, self.height-20)];
    
    rightLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [leftView addSubview:imageView];
    [leftView addSubview:label];
    [leftView addSubview:rightLine];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
}
@end
