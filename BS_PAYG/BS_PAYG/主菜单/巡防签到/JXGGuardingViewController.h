//
//  JXGGuardingViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/9.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXGGuardingViewController : UIViewController

//属性
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *distance_label;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

//事件
- (IBAction)finish:(UIButton *)sender;

- (IBAction)backHome:(UIBarButtonItem *)sender;

@end

NS_ASSUME_NONNULL_END
