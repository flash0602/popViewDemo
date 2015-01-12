//
//  ContactSort.m
//  OatosIphoneClient2.0
//
//  Created by 黄樊 on 13-10-29.
//  Copyright (c) 2013年 qycloud. All rights reserved.
//

#import "ContactSort.h"

@implementation ContactSort

- (id)init
{
	if (self = [super init])
	{
		m_pResultArray = [[NSMutableArray alloc] init];
	}
	
	return self;
}

/*
 本机通讯录排序
 */
- (void)sortArray:(NSArray *)arr addCompletionHandler:(OatosBaseBlock)response
{
	
	if ([m_pResultArray count] > 0)
	{
		[m_pResultArray removeAllObjects];
	}
	
	NSMutableArray *pSortArray = [[NSMutableArray alloc] init];
	
	NSMutableArray *pSectionArray = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",
									 @"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",
									 @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",
									 @"X",@"Y",@"Z",@"#",nil];
	for (int nLoop = 0; nLoop < [pSectionArray count]; nLoop++)
	{
		NSString *str = [pSectionArray objectAtIndex:nLoop];
		NSMutableDictionary *pDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:str,@"section",nil];
		[pSortArray addObject:pDic];
	}
	
	NSArray *pSourceArray = compareArray(arr);
	NSMutableArray *pGroupArray = [[NSMutableArray alloc] initWithArray:pSourceArray];
	
	for (int i = 0; i < [pGroupArray count]; i++)
	{
		NSString *strSelf = [[pGroupArray objectAtIndex:i] objectForKey:@"self"];
		NSString *strName = nil;
		
		if ([strSelf isEqualToString:@"1"])
		{
			strName = [[pGroupArray objectAtIndex:i] objectForKey:kOatosParamsUserName];
		}
		else
		{
			strName = [[pGroupArray objectAtIndex:i] objectForKey:kOatosParamsRealName];
            if (strName == nil||strName.length == 0)
            {
                strName = [[pGroupArray objectAtIndex:i] objectForKey:kOatosParamsUserName];
            }
		}
		
		if (strName.length > 0)
		{
			char firstchar = pinyinFirstLetter([strName characterAtIndex:0]);
			char first[2] = {firstchar};
			NSString *str = [NSString stringWithUTF8String:first];
			NSMutableDictionary *pDic = [[NSMutableDictionary alloc] initWithDictionary:[pGroupArray objectAtIndex:i]];
			if(str)
                [pDic setObject:str forKey:@"firstname"];
			[pGroupArray replaceObjectAtIndex:i withObject:pDic];
		}
	}
	
	for (int k = 0; k < [pSortArray count]; k++)
	{
		NSString *strSection = [[pSortArray objectAtIndex:k] objectForKey:@"section"];
		
		NSMutableArray *pTempArray = [[NSMutableArray alloc] init];
		
		for (int j = 0; j < [pGroupArray count]; j++)
		{
			NSString *strFirstName = [[pGroupArray objectAtIndex:j] objectForKey:@"firstname"];
			if (strFirstName)
            {
                if ([strSection rangeOfString:strFirstName
                                      options:NSCaseInsensitiveSearch].location != NSNotFound)
                {
                    [pTempArray addObject:[pGroupArray objectAtIndex:j]];
                }
            }
		}
		
		if ([pTempArray count] > 0)
		{
			[[pSortArray objectAtIndex:k] setValue:pTempArray forKey:@"sectioncontent"];
			[m_pResultArray addObject:[pSortArray objectAtIndex:k]];
		}
	}
	
    response(m_pResultArray);
}

/*
 自定义比较函数
 */
NSInteger contactCompare(id user,id comuser,void *context)
{
	NSString *strName = [(NSDictionary *)user objectForKey:kOatosParamsRealName];
	NSString *strComName = [(NSDictionary *)comuser objectForKey:kOatosParamsRealName];
	
	return [strName localizedCompare:strComName];
}

/*
 使用自定义函数对本机通讯录排序
 */
NSArray *compareArray(NSArray *arr)
{
	return [arr sortedArrayUsingFunction:contactCompare context:nil];
}

@end
