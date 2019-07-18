//
//  BMKSportNode.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/9.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//**********************************运动结点信息类**********************************
@interface BMKSportNode : NSObject
//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//速度
@property (nonatomic, assign) CGFloat speed;
@end
