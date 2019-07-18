//
//  JDModel.m
//  view_testTests
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "JDModel.h"

@implementation JDModel

- (void)setCom:(NSArray<SQModel *> *)com{
    _com = [SQModel mj_objectArrayWithKeyValuesArray:com];
}

@end
