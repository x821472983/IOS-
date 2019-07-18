//
//  UserModel.h
//  view_testTests
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//
//  用户信息模型 单例 登录后创建

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

///获取单例
+(instancetype)getInstance;

@property(nonatomic, strong)NSString *sessionId;//会话

@property(nonatomic, strong)NSString *name;//用户名
@property(nonatomic, strong)NSString *passWord;//用户名
@property(nonatomic, strong)NSString *userId;//ID
@property(nonatomic, strong)NSString *card;//身份证
@property(nonatomic, strong)NSString *birthday;//出生年月日
@property(nonatomic, strong)NSString *age;
@property(nonatomic, strong)NSString *intergral;//积分

@property(nonatomic, strong)NSString *deptName;
@property(nonatomic, strong)NSString *communityName;
@property(nonatomic, strong)NSString *unitName;
@property(nonatomic, strong)NSString *phone;

@property(nonatomic, strong)NSString *sex;
@property(nonatomic, strong)NSString *deptId;

#pragma mark - [全局功能性属性]
//最近巡防开始时间
@property(nonatomic, strong)NSString *beginTime;

//最近巡防所选社区名称
@property(nonatomic, strong)NSString *sqName;
//最近巡防所选社区id
@property(nonatomic, strong)NSString *sqId;

- (void)setDic : (NSDictionary *)dic;

- (void)  : (NSDictionary *)rolefunctions;

@end
