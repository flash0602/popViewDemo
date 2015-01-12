//
//  NSString+MD5.m
//  OatosClient
//
//  Created by 黄樊 on 13-4-3.
//  Copyright (c) 2013年 oatos. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *)MD5
{
    return [NSString MD5ByAStr:self];
}

+ (NSString *)MD5ByAStr:(NSString *)aSourceStr {
    const char* cStr = [aSourceStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

@end
