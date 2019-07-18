//
//  JXGTrackViewController.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/9.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKSportNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXGTrackViewController : UIViewController

//轨迹相关数据
@property(nonatomic, strong)NSMutableArray<BMKSportNode *> *sportNodes;
@property(nonatomic, strong)NSNumber *sportNodeNum;
@property(nonatomic, strong)NSNumber *timeCount;
@property(nonatomic, strong)NSNumber *distance;

//属性
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *score_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *distance_label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *upload_btn;

//返回首页
- (IBAction)goHome:(UIBarButtonItem *)sender;
- (IBAction)uploadAction:(UIBarButtonItem *)sender;
@end

NS_ASSUME_NONNULL_END
