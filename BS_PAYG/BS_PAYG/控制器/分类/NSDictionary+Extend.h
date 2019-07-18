//
//  NSDictionary+Extend.h
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDictionary(Extend)

/**
 * 将 字典 转成 type_id=1&zone_id=1 需要的url
 */
- (NSMutableString *)urlLinkParam;

///根据plist文件名字 获取字典
+ (NSDictionary *)dictionaryWithContentsOfPlistName:(NSString *)plistName;

@end
