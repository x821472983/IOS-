//
//  YCManager.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/4/1.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "YCManager.h"

@implementation YCManager

static YCManager *manager;
+(instancetype)getInstance{
    if (!manager) {
        manager = [[self alloc] init];
    }
    return manager;
}

#pragma mark - [懒加载]
///创建AF管理
-(AFHTTPSessionManager *)AFManager{
    if (!_AFManager) {
        _AFManager = [AFHTTPSessionManager manager];
        //设置超时时间15秒
        [_AFManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _AFManager.requestSerializer.timeoutInterval = 15;
        [_AFManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        //
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        _AFManager.responseSerializer = response;
    }
    return _AFManager;
}


#pragma mark - [公共方法]
- (void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    [self.AFManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
- (void)GET:(NSString *)urlStr successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    [self.AFManager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


#pragma mark - [请求]
#define loginUrl [NSString stringWithFormat:@"%@/user/login?",HOST]
//#define loginUrl [NSString stringWithFormat:@"%@/user/easyLogin?",HOST]
#pragma mark 登录
- (void)Guard_login_userName : (NSString *)userName password : (NSString *)password successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    NSDictionary *paramDic = @{
                               @"phone" : userName,
                               @"password" : password,
                               };
    
    [self POST:loginUrl parameters:paramDic successHandle:success failureHandle:failure];
//    [self GET:@"http://120.78.197.77:8888/user/getById?UserID=1"  successHandle:success failureHandle:failure];
}

#define registerUrl [NSString stringWithFormat:@"%@/user/register?",HOST]
#pragma mark 注册
- (void)Guard_register_name : (NSString *)name password : (NSString *)password birthday : (NSString *)birthday sex : (NSString *)sex phone : (NSString *)phone card : (NSString *)card  deptName : (NSString *)deptName unitName : (NSString *)unitName communityName : (NSString *)communityName successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    NSString *birthday3 = [birthday stringByReplacingOccurrencesOfString:@"-" withString:@"/"];//替换字符
    
    NSDictionary *paramDic = @{
                               @"name" : name,//姓名
                               @"sex" : sex,//性别
                               @"birthday" : birthday3,//年龄
                               @"phone" : phone,//手机号码
                               @"card" : card,//身份证
                               @"password" : password,//密码
                               @"deptName" : deptName,//派出所名称
                               @"communityName" : communityName,//社区名称
                               @"unitName" : unitName//单位名称
                               };

    [self POST:registerUrl parameters:paramDic successHandle:success failureHandle:failure];
}

#define CheckUserDataUrl [NSString stringWithFormat:@"%@/user/findPhone?",HOST]
#pragma mark 重置密码
- (void)Guard_CheckUserData_name : (NSString *)name phone : (NSString *)phone card : (NSString *)card deptName : (NSString *)deptName unitName : (NSString *)unitName communityName : (NSString *)communityName successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    NSDictionary *paramDic = @{
                               @"name" : name,//姓名
                               @"phone" : phone,//手机号码
                               @"card" : card,//身份证
                               @"deptName" : deptName,
                               @"communityName" : communityName,//社区名称
                               @"unitName" : unitName//单位名称
                               };
    
    [self POST:CheckUserDataUrl parameters:paramDic successHandle:success failureHandle:failure];
}

#define updatePwdUrl [NSString stringWithFormat:@"%@/user/forgetAndResetPassword?",HOST]
#pragma mark 重设密码
- (void)Guard_updatePwd_userName : (NSString *)userName password : (NSString *)password successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    NSDictionary *paramDic = @{
                               @"name" : userName,//姓名
                               @"newPassword" : password
                               };
    
    [self POST:updatePwdUrl parameters:paramDic successHandle:success failureHandle:failure];
}


#define updateSysUserAppUrl [NSString stringWithFormat:@"%@/user/updateUser?",HOST]
#pragma mark 修改个人信息
- (void)Guard_updateSysUserApp_name : (NSString *)name birthday : (NSString *)birthday phone : (NSString *)phone card : (NSString *)card deptName : (NSString *)deptName communityName : (NSString *)communityName unitName : (NSString *)unitName userId : (NSString *)userId successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    NSString *birthday2 = [birthday stringByReplacingOccurrencesOfString:@"-" withString:@"/"];//替换字符
    
    NSDictionary *paramDic = @{
                               @"name" : name,
                               @"phone" : phone,
                               @"card" : card,
                               @"deptName" : deptName,
                               @"communityName" : communityName,
                               @"unitName" : unitName,
                               @"birthday" : birthday2,
                               @"userId" : userId

                               };
    
    
    [self POST:updateSysUserAppUrl parameters:paramDic successHandle:success failureHandle:failure];
}


#define updatePwd2Url [NSString stringWithFormat:@"%@/user/resetPassword?",HOST]
#pragma mark 重设密码
- (void)Guard_updatePwd_userId : (NSString *)userId oldPassword : (NSString *)oldPassword newPassword : (NSString *)newPassword successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    NSDictionary *paramDic = @{
                               @"userId" : userId,//姓名
                               @"oldPassword" : oldPassword,
                               @"newPassword" : newPassword
                               };
    
    [self POST:updatePwd2Url parameters:paramDic successHandle:success failureHandle:failure];
}

#define selectDeptUrl [NSString stringWithFormat:@"%@/DCS/selectDept?",HOST]
#pragma mark 查询派出所
- (void)selectDept_successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{

    
    [self POST:selectDeptUrl parameters:nil successHandle:success failureHandle:failure];
}

#define selectCommunityUrl [NSString stringWithFormat:@"%@/DCS/selectCommunity",HOST]
#pragma mark 查询社区
- (void)selectCommunity_successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{

    
    [self POST:selectCommunityUrl parameters:nil successHandle:success failureHandle:failure];
}


#define selectStreetUrl [NSString stringWithFormat:@"%@/DCS/selectStreetAndCom?",HOST]
#pragma mark 查询街道
- (void)selectStreet_successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{

    [self POST:selectStreetUrl parameters:nil successHandle:success failureHandle:failure];
}

#define uploadPatrolsUrl [NSString stringWithFormat:@"%@/user/uploadPatrols?",HOST]
#pragma mark 巡防上传
- (void)Guard_uploadPatrols_userId : (NSString *)userId intergral : (NSString *)intergral timeCount : (NSString *)timeCount successHandle : (void (^)(id data))success failureHandle : (void (^)(id error))failure{
    
    NSDictionary *paramDic = @{
                               @"userId" : userId,//姓名
                               @"intergral" : intergral,
                               @"timeCount" : timeCount
                               };
    
    [self POST:uploadPatrolsUrl parameters:paramDic successHandle:success failureHandle:failure];
}
@end
