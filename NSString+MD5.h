//
//  NSString+MD5.h
//  OatosClient
//
//  Created by 黄樊 on 13-4-3.
//  Copyright (c) 2013年 oatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5;
+ (NSString *)MD5ByAStr:(NSString *)aSourceStr;

@end
