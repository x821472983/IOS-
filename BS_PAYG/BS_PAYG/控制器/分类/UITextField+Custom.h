//
//  UITextField+Custom.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UITextField (Custom)

/**
 * 设置播报哥左边View的图片，与setLeftViewWithTitle，setsetLeftViewWithImageAndWithTitle冲突
 * @param imageName 左边的图片名称，为空则显示title 优先级高
 */
- (void)setLeftViewWithImage:(NSString *)imageName;

/**
 * 设置播报哥左边View的文字，与setLeftViewWithImage，setsetLeftViewWithImageAndWithTitle冲突
 * @param title 左边的文字 为空则不显示leftView 优先级底
 */
- (void)setLeftViewWithTitle:(NSString *)title;

/**
 * 设置播报哥左边View的图片与文字，与setLeftViewWithImage，setLeftViewWithTitle冲突
 * @param title 左边的图片和文字 为空则不显示leftView 优先级底
 */
- (void)setLeftViewWithImage:(NSString *)imageName AndWithTitle:(NSString *)title;
@end
