//
//  EditPwdViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Old_Pwd;
@property (weak, nonatomic) IBOutlet UITextField *New_Pwd;
@property (weak, nonatomic) IBOutlet UITextField *New_Pwd2;
@property (weak, nonatomic) IBOutlet UIButton *Reset_Pwd;

- (IBAction)Reset_Pwd:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
