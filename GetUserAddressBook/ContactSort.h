//
//  ContactSort.h
//  OatosIphoneClient2.0
//
//  Created by 黄樊 on 13-10-29.
//  Copyright (c) 2013年 qycloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "pinyin.h"
#import "POAPinyin.h"

@interface ContactSort : NSObject
{
	NSMutableArray *m_pResultArray;
}

/* 本机通讯录排序 */
- (void)sortArray:(NSArray *)arr addCompletionHandler:(OatosBaseBlock) response;

@end
