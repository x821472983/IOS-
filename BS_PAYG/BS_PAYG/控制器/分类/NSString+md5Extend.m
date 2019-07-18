//
//  NSString+md5Extend.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//


#import "NSString+md5Extend.h"
//在其他平台中经常会计算MD5值，在ios平台中也提供了该方法，首先需要导入头文件
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(md5Extend)

-(NSString *)md5
{
    const char *cStr = [self UTF8String];//转化成c语言字符串
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    
    //方法CC_MD5可以获取MD5的16个字符的数组，再通过%02X的形式输出即可获取32位MD5值。
    CC_MD5( cStr, (unsigned int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
//MD5只能称为一种不可逆的加密算法，只能用作一些检验过程，不能恢复其原文。


@end
