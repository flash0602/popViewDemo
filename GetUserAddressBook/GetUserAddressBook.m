//
//  GetUserAddressBook.m
//  OatosIphoneClient2.0
//
//  Created by qycloud on 13-7-1.
//  Copyright (c) 2013年 qycloud. All rights reserved.
//

#import "GetUserAddressBook.h"

@implementation GetUserAddressBook

-(id)init
{
    if (self = [super init])
    {
        self.isForbidden = NO;
        
        /* 创建通讯录指针 */
        [self initAddressBook];
        
        /* 获取通讯录数据 */
        allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        nPeople =ABAddressBookGetPersonCount(addressBook);
        addressArray = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

- (void)initAddressBook
{
    addressBook = NULL;
    __block BOOL accessGranted = NO;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        // we're on iOS 6
        addressBook = ABAddressBookCreateWithOptions(NULL, nil);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
        if (!accessGranted)
        {
            self.isForbidden = NO;
            addressBook = nil;
        }
        else
        {
            self.isForbidden = YES;
        }

    }
    else
    {
        // we're on iOS 5 or older
        addressBook = ABAddressBookCreate();
    }
}

- (NSMutableArray *)GetAddressInfo
{
    if (addressArray) {
        [addressArray removeAllObjects];
    }
    
    for (int i = 0; i < nPeople; i++)
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        ABMutableMultiValueRef phoneNumber = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        NSString *phoneStr = nil;
        
        for (int j = 0; j < ABMultiValueGetCount(phoneNumber); j++)
        {
            CFStringRef labelRef = ABMultiValueCopyLabelAtIndex(phoneNumber, j);
            CFStringRef numberRef = ABMultiValueCopyValueAtIndex(phoneNumber, j);
            //可以通过元组的label来判定这个电话是哪种电话，比如下面就包括：主电话，手机，工作传真
            if ([(NSString *)labelRef isEqualToString:(NSString *) kABPersonPhoneMobileLabel]
                || [(NSString *)labelRef isEqualToString:(NSString *) kABPersonPhoneIPhoneLabel]
                || [(NSString *)labelRef isEqualToString:(NSString *) kABPersonPhoneMainLabel]
                ||[(NSString *)labelRef isEqualToString:@"手机号码"])
            {
                phoneStr = [NSString stringWithFormat:@"%@",(NSString *)numberRef];
                if (numberRef != nil)
                {
                    CFRelease(numberRef);
                }
                
                if (labelRef != nil)
                {
                    CFRelease(labelRef);
                }
                break;
            }

            if (numberRef != nil)
            {
               CFRelease(numberRef);
            }
            
            if (labelRef != nil)
            {
                CFRelease(labelRef);
            }
            
        }
        
        if(phoneStr)
            phoneStr = [self getFormatString:phoneStr];
        
        NSString* contactFisrtadnLast = nil;
        if (firstName == nil)
        {
            contactFisrtadnLast = [[NSString alloc] initWithFormat:@"%@", (NSString *)lastName];
        }
        else if (lastName == nil)
        {
            contactFisrtadnLast = [[NSString alloc] initWithFormat:@"%@", (NSString *)firstName];
        }
        else
        {
            contactFisrtadnLast = [[NSString alloc] initWithFormat:@"%@%@", (NSString *)lastName, (NSString *)firstName];
        }
        
		NSDictionary *pDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              contactFisrtadnLast,@"realName",
							  phoneStr, @"mobile",
                              @"0", @"self", nil];
		[addressArray addObject:pDic];
		
        [pDic release];
        [contactFisrtadnLast release];
        
        if (firstName != nil)
        {
            CFRelease(firstName);
        }
        
        if (lastName != nil)
        {
            CFRelease(lastName);
        }
        
        if (phoneNumber != nil)
        {
            CFRelease(phoneNumber);
        }
    }
    
    return addressArray;
}

- (NSString *)getFormatString:(NSString*)infoString
{
    NSInteger stringPostion = 0;
    NSInteger stringLength =  [infoString length];
    char *infoChar = (char *)[infoString UTF8String];
    while (stringPostion < stringLength)
    {
        if (*(infoChar+stringPostion) == '-'||*(infoChar+stringPostion)=='('||*(infoChar+stringPostion)==')'||*(infoChar+stringPostion)==' ')
        {
            NSInteger x;
            for (x = stringPostion; x<stringLength; x++)
            {
                *(infoChar+x) = *(infoChar+x+1);
                
            }
            //  *(infoChar+x) = '\0';
            stringLength -= 1;
        }
        else
        {
            stringPostion ++;
        }
    }
    
    return [[[NSString alloc] initWithCString:infoChar encoding:NSUTF8StringEncoding] autorelease];
}

- (void)dealloc
{
    [addressArray release];
    [super dealloc];
}

@end
