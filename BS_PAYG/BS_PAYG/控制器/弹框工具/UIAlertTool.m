//
//  UIAlertTool.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/5.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "UIAlertTool.h"

typedef void (^confirm)(void);
typedef void (^confirmO)(void);
typedef void (^cancle)(void);

@interface UIAlertTool(){
    
    //供老版本调用
    confirm confirmParam;//确定
    confirmO confirmParamO;//确定
    cancle  cancleParam;//取消
}

@property(nonatomic, strong)UIAlertView  *alertView;
@property(nonatomic, strong)UIActionSheet  *actionView;

@end

@implementation UIAlertTool

-(void)showAlertViewOn:(UIViewController *)viewController
                 title:(NSString *)title
               message:(NSString *)message
      otherButtonTitle:(NSString *)otherButtonTitle
     cancelButtonTitle:(NSString *)cancelButtonTitle
         confirmHandle:(void (^)(void))confirm
          cancleHandle:(void (^)(void))cancle{
    
    //解决传入nil就报错的问题
    if (confirm == nil)  confirm = ^{};
    if (cancle == nil)  cancle = ^{};
    
    confirmParam = confirm;
    cancleParam = cancle;
    
    if (iOS8Later) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        //是否需要取消按钮
        if(cancelButtonTitle){
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cancle();
            }];
            [alertController addAction:cancelAction];
        }
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirm();
        }];
        [alertController addAction:otherAction];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
    }else{
        //这里的Cancel与Other调换位置是因为iOS默认把取消按钮放在第一个
        _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:otherButtonTitle otherButtonTitles:cancelButtonTitle,nil];
        [_alertView show];
    }
}

-(void)showActionSheetOn:(UIViewController *)viewController
                   title:(NSString *)title
                 message:(NSString *)message
       otherButtonTitle1:(NSString *)otherButtonTitle1
       otherButtonTitle2:(NSString *)otherButtonTitle2
       cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmHandle:(void (^)(void))confirm
          confirmHandleO:(void (^)(void))confirmO
            cancleHandle:(void (^)(void))cancle{
    
    confirmParam=confirm;
    confirmParamO=confirmO;
    cancleParam=cancle;
    
    if (iOS8Later) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        //暂时不需要取消按钮
        if(cancelButtonTitle){
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                cancle();
            }];
            [alertController addAction:cancelAction];
        }
        
        UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:otherButtonTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirm();
        }];
        UIAlertAction *otherAction2 = [UIAlertAction actionWithTitle:otherButtonTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirmO();
        }];
        [alertController addAction:otherAction1];
        [alertController addAction:otherAction2];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        _actionView = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitle1,otherButtonTitle2, nil];
        [_actionView showInView:viewController.view];
    }
}

#pragma mark - [UIAlertView代理]
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        confirmParam();
    }else{
        cancleParam();
    }
}

#pragma mark - [UIActionSheet代理]
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        confirmParam();
    }
    else if (buttonIndex==1){
        confirmParamO();
    }
    else{
        cancleParam();
    }
}

#pragma mark - [MBProgressHUD]
+(MBProgressHUD *)showHUD:(UIView *)view message:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    //样式调整
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 10;//边距
    [hud hideAnimated:YES afterDelay:1.8f];
    return hud;
}

+(void)showHUDToViewCenter:(UIView *)view message:(NSString *)message{
   [self showHUD:view message:message].offset = CGPointMake(0.f, 0.f);
}

+(void)showHUDToViewTop:(UIView *)view message:(NSString *)message{
    [self showHUD:view message:message].offset = CGPointMake(0.f, -50);
}

+(void)showHUDToViewBottom:(UIView *)view message:(NSString *)message{
    [self showHUD:view message:message].offset = CGPointMake(0.f, MBProgressMaxOffset);
}

@end
