//
//  YCManager.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/4/1.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST @"http://47.101.206.181:8080"
//#define HOST @"http://127.0.0.1:8080"
NS_ASSUME_NONNULL_BEGIN
@interface YCManager : NSObject
#pragma mark - [属性]
@property (nonatomic,strong)AFHTTPSessionManager *AFManager;
#pragma mark - [行为]
///获取单例
+(instancetype)getInstance;

#pragma mark - [登录注册相关]
///登录
- (void)Guard_login_userName : (NSString *)userName password : (NSString *)password successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

///注册
- (void)Guard_register_name : (NSString *)name password : (NSString *)password birthday : (NSString *)birthday sex : (NSString *)sex phone : (NSString *)phone card : (NSString *)card deptName : (NSString *)deptName unitName : (NSString *)unitName  communityName : (NSString *)communityName successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

///重置密码
- (void)Guard_CheckUserData_name : (NSString *)name phone : (NSString *)phone card : (NSString *)card deptName : (NSString *)deptName unitName : (NSString *)unitName communityName : (NSString *)communityName successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

///重设密码
- (void)Guard_updatePwd_userName : (NSString *)userName password : (NSString *)password successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

///修改个人信息
- (void)Guard_updateSysUserApp_name : (NSString *)name birthday : (NSString *)birthday phone : (NSString *)phone card : (NSString *)card deptName : (NSString *)deptName communityName : (NSString *)communityName unitName : (NSString *)unitName userId : (NSString *)userId successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

///重设密码
- (void)Guard_updatePwd_userId : (NSString *)userId oldPassword : (NSString *)oldPassword newPassword : (NSString *)newPassword successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

///查询派出所
- (void)selectDept_successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

//查询社区
- (void)selectCommunity_successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

//查询街道与社区
- (void)selectStreet_successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;

//巡防结束上传信息
- (void)Guard_uploadPatrols_userId : (NSString *)userId intergral : (NSString *)intergral timeCount : (NSString *)timeCount successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure;
@end

NS_ASSUME_NONNULL_END
