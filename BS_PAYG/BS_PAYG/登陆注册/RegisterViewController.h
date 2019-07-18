//
//  RegisterViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController
//元素属性
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *card;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *superPassword;
@property (weak, nonatomic) IBOutlet UITextField *unitName;

@property (weak, nonatomic) IBOutlet UIButton *man_button;
@property (weak, nonatomic) IBOutlet UIButton *woman_button;

@property (weak, nonatomic) IBOutlet UIButton *birthday;
@property (weak, nonatomic) IBOutlet UIButton *policeClicked;
@property (weak, nonatomic) IBOutlet UIButton *communityClicked;
@property (weak, nonatomic) IBOutlet UIButton *Register;

//点击事件
- (IBAction)Man:(UIButton *)sender;
- (IBAction)Women:(UIButton *)sender;
- (IBAction)Birthday:(UIButton *)sender;
- (IBAction)PoliceClicked:(UIButton *)sender;
- (IBAction)communityClicked:(UIButton *)sender;
- (IBAction)Register:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
