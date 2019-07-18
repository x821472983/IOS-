//
//  ResetPwdViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResetPwdViewController : UIViewController

@property(nonatomic, strong)NSString *name;

@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UITextField *Password2;

- (IBAction)ResetPwd:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
