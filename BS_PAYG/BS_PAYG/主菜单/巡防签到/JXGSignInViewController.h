//
//  JXGSignInViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXGSignInViewController : UIViewController

//属性

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *beginBtn;

//事件
- (IBAction)selectLocation:(UIButton *)sender;

- (IBAction)begin:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
