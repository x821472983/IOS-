//
//  NSDictionary+Extend.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//


#import "NSDictionary+Extend.h"

@implementation NSDictionary(Extend)

- (NSMutableString *)urlLinkParam
{
    if (!self) {
        return [NSMutableString stringWithFormat:@""];
    }
    
    NSMutableString *params = [NSMutableString string];
    NSArray *keys = [self allKeys];
    for (int i=0;i<keys.count ;i++) {
        NSString * key = keys[i];
        NSString * value = [self objectForKey:key];
        if (i == keys.count-1) {
            [params appendFormat:@"%@=%@",key,value];
        }else{
            [params appendFormat:@"%@=%@&",key,value];
        }
    }
    return params;
}

+ (NSDictionary *)dictionaryWithContentsOfPlistName:(NSString *)plistName{
    
    return [[self alloc] initWithContentsOfPlistName:plistName];
}

- (NSDictionary *)initWithContentsOfPlistName:( NSString *)plistName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dicData = [self initWithContentsOfFile:[[paths firstObject] stringByAppendingPathComponent:plistName]];
    return dicData;
}

@end
