//
//  ForgetPwdViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPwdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *card;
@property (weak, nonatomic) IBOutlet UITextField *unitName;
@property (weak, nonatomic) IBOutlet UIButton *policeClicked;
@property (weak, nonatomic) IBOutlet UIButton *communityClicked;
@property (weak, nonatomic) IBOutlet UIButton *Reset_Button;


- (IBAction)Reset_Button:(UIButton *)sender;
- (IBAction)PoliceClicked:(UIButton *)sender;
- (IBAction)communityClicked:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
