//
//  GetUserAddressBook.h
//  OatosIphoneClient2.0
//
//  Created by qycloud on 13-7-1.
//  Copyright (c) 2013年 qycloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface GetUserAddressBook : NSObject
{
    ABAddressBookRef addressBook;
    CFArrayRef allPeople;
    CFIndex nPeople;
    NSMutableArray *addressArray;
    
}

@property (nonatomic,assign) BOOL isForbidden;

- (NSMutableArray *)GetAddressInfo;
- (NSString *)getFormatString:(NSString*)infoString;

@end
