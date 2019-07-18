//
//  UserModel.m
//  view_testTests
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//
#import "UserModel.h"

@implementation UserModel

static UserModel *model;
+(instancetype)getInstance{
    if (!model) {
        model = [[self alloc] init];
    }
    return model;
}

- (void)setDic : (NSDictionary *)dic{
    
    model.name = dic[@"name"];
    model.card = [NSString stringWithFormat:@"%@", dic[@"card"]?:@""];
    
    long timeStamp = [dic[@"birthday"] longValue]/1000;
    if (timeStamp > 0) {
        NSDateFormatter *format = [NSDateFormatter new];
        format.dateFormat = @"yyyy-MM-dd";
        model.birthday = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
    }
    else{
        model.birthday = @"";
    }
    
    model.age = [NSString stringWithFormat:@"%@", dic[@"age"]?:@""];
    model.intergral = [NSString stringWithFormat:@"%@", dic[@"intergral"]?:@"0"];
    
    model.deptName = dic[@"deptName"];
    model.communityName = [NSString stringWithFormat:@"%@", dic[@"communityName"]?:@""];
    model.unitName = dic[@"unitName"];
    model.phone = [NSString stringWithFormat:@"%@", dic[@"phone"]?:@""];
    
    model.sex = dic[@"sex"];
    model.deptId = dic[@"deptId"];
}

@end
