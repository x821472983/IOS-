//
//  UIAlertTool.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/5.
//  Copyright © 2019 梁志华. All rights reserved.
//
//  封装的弹出提示窗，支持新老版本
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertTool : NSObject<UIAlertViewDelegate, UIActionSheetDelegate>

///Alert
-(void)showAlertViewOn:(UIViewController *)viewController
                         title:(NSString *)title
                       message:(NSString *)message
              otherButtonTitle:(NSString *)otherButtonTitle
             cancelButtonTitle:(NSString *)cancelButtonTitle
                 confirmHandle:(void (^)(void))confirm
                  cancleHandle:(void (^)(void))cancle;

///ActionSheet
-(void)showActionSheetOn:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
               otherButtonTitle1:(NSString *)otherButtonTitle1
               otherButtonTitle2:(NSString *)otherButtonTitle2
               cancelButtonTitle:(NSString *)cancelButtonTitle
                   confirmHandle:(void (^)(void))confirm
                  confirmHandleO:(void (^)(void))confirmO
                    cancleHandle:(void (^)(void))cancle;

/**
 * 文本框HUD效果中心显示，1.8秒后自动消息
 * @praram view 显示位置
 * @praram message 显示的消息
 */
+(void)showHUDToViewCenter:(UIView *)view message:(NSString *)message;

/**
 * 文本框HUD效果顶部显示，1.8秒后自动消息
 * @praram view 显示位置
 * @praram message 显示的消息
 */
+(void)showHUDToViewTop:(UIView *)view message:(NSString *)message;

/**
 * 文本框Toast效果底部显示，1.8秒后自动消息
 * @praram view 显示位置
 * @praram message 显示的消息
 */
+(void)showHUDToViewBottom:(UIView *)view message:(NSString *)message;

@end
