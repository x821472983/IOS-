//
//  EditSelfInfoViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditSelfInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *card;
@property (weak, nonatomic) IBOutlet UITextField *unitName;

@property (weak, nonatomic) IBOutlet UIButton *birthday_button;
@property (weak, nonatomic) IBOutlet UIButton *police_button;
@property (weak, nonatomic) IBOutlet UIButton *community_button;

- (IBAction)PoliceClicked:(UIButton *)sender;
- (IBAction)communityClicked:(UIButton *)sender;
- (IBAction)Birthday:(UIButton *)sender;
- (IBAction)Edit_Button:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
