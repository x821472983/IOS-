//
//  LoginViewController.h
//  view_testTests
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *account_textField;
@property (weak, nonatomic) IBOutlet UITextField *password_textField;
@property (weak, nonatomic) IBOutlet UIButton *RemenberPassword;
@property (weak, nonatomic) IBOutlet UIButton *AutoLogin;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;


- (IBAction)RemenberPassword:(UIButton *)sender;
- (IBAction)AutoLogin:(UIButton *)sender;
- (IBAction)LoginButton:(UIButton *)sender;

- (void) success;
@end

NS_ASSUME_NONNULL_END
