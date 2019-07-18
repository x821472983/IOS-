//
//  JDModel.h
//  view_testTests
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//
//  街道

#import <Foundation/Foundation.h>
//社区
#import "SQModel.h"

@interface JDModel : NSObject

@property(nonatomic, strong)NSString *streetName;
@property(nonatomic, strong)NSString *streetId;
@property(nonatomic, strong)NSArray<SQModel *> *com;

@end
