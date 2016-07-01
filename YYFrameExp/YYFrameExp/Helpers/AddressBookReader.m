//
//  AdressBookReader.m
//  FlowExp
//
//  Created by Dongle Su on 14-4-21.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "AddressBookReader.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TKContact.h"
#import "NSString+TKUtilities.h"
#import "Tip.h"
//#import "pinyin.h"
//#import "PinYinForObjc.h"
//#import "MobileCarrier.h"

@implementation AddressBookReader

+ (AddressBookReader *)sharedInstance{
    static AddressBookReader *webService=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webService = [[AddressBookReader alloc] init];
    });
    return webService;
}

- (BOOL)isBinded{
    if (ABAddressBookGetAuthorizationStatus) {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusAuthorized) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}
- (void)bindSuccess:(void(^)())successed failed:(void(^)(NSString *errorDescription))failed{
    if (ABAddressBookGetAuthorizationStatus) {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
            failed(@"请到设置->隐私->通讯录中设置");
            return;
        }
    }

    ABAddressBookRef addressBooks = ABAddressBookCreate();
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            if (granted) {
                successed();
            }
            else{
                failed(@"未获得通讯录访问权限");
            }
        });
    }
    else{
        successed();
    }
    if(addressBooks) CFRelease(addressBooks);
}
- (BOOL)bind{
    __block BOOL isGranted;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [self bindSuccess:^{
        isGranted = YES;
        dispatch_semaphore_signal(sema);
    } failed:^(NSString *errorDescription) {
        dispatch_semaphore_signal(sema);
        isGranted = NO;
        [Tip tipError:errorDescription OnView:nil];
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //dispatch_release(sema);
    return isGranted;
}
- (void)reloadAddressBookSuccess:(void(^)())successed failed:(void(^)(NSString *errorDescription))failed
{
    self.contactArray = nil;    
    self.noSortContactArray = nil;

    ABAddressBookRef addressBooks = ABAddressBookCreate();
    
    //__block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        //dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            //accessGranted = granted;
            //dispatch_semaphore_signal(sema);
            if (granted) {
                [self reloadAddressBookThreadly];
                successed();
            }
            else{
                failed(@"未获得通讯录访问权限");
            }
        });
        //dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else{
        dispatch_queue_t queue = dispatch_queue_create("readAddressbook_queue", NULL);
        dispatch_async(queue, ^(void){
            [self reloadAddressBookThreadly];
            successed();
        });
    }
    
    if(addressBooks) CFRelease(addressBooks);
}

- (void)reloadAddressBookThreadly{
    [self.contactArray removeAllObjects];
    self.contactArray = nil;
    
    [self.noSortContactArray removeAllObjects];
    self.noSortContactArray = nil;

    // Create addressbook data model
    NSMutableArray *contactsTemp = [NSMutableArray array];
    ABAddressBookRef addressBooks = ABAddressBookCreate();
    
    CFArrayRef allPeople;
    CFIndex peopleCount;
    allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //peopleCount = ABAddressBookGetPersonCount(addressBooks);
    peopleCount = CFArrayGetCount(allPeople);
    
    for (NSInteger i = 0; i < peopleCount; i++)
    {
        ABRecordRef contactRecord = CFArrayGetValueAtIndex(allPeople, i);
        
        // Thanks Steph-Fongo!
        if (!contactRecord) continue;
        
        CFStringRef abName = ABRecordCopyValue(contactRecord, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(contactRecord, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(contactRecord);
        
        NSString *fullNameString;
        NSString *firstString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            fullNameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                fullNameString = [NSString stringWithFormat:@"%@ %@", firstString, lastNameString];
            }
        }
        NSData *imageData;// = [[NSData alloc] init];
        imageData = (__bridge NSData *)ABPersonCopyImageData(contactRecord);
        UIImage *myImage = [UIImage imageWithData:imageData];
        if (imageData) {
            CFRelease((__bridge CFTypeRef)(imageData));
        }

        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(contactRecord, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                if(valuesRef != nil){
                    CFRelease(valuesRef);
                }
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *formatedTel = [(__bridge NSString*)value telephoneWithReformat];
//                        NSMutableArray *headerToRemoveArray;
//                        if ([WebService sharedInstance].ipTelPrefix) {
//                            headerToRemoveArray = [NSMutableArray arrayWithArray:[WebService sharedInstance].ipTelPrefix];
//                        }
//                        else{
//                            headerToRemoveArray = [NSMutableArray array];
//                        }
//                        [headerToRemoveArray addObject:@"86"];
//                        
//                        for (NSString *head in headerToRemoveArray) {
//                            if ([formatedTel hasPrefix:head]) {
//                                formatedTel = [formatedTel substringFromIndex:[head length]];
//                                break;
//                            }
//                        }
                        if ([formatedTel length] == 11) {
                            TKContact *contact = [[TKContact alloc] init];
                            contact.name = fullNameString;
                            contact.recordID = (int)ABRecordGetRecordID(contactRecord);
                            contact.rowSelected = NO;
                            contact.lastName = (__bridge NSString*)abLastName;
                            contact.firstName = (__bridge NSString*)abName;
                            contact.thumbnail = myImage;
                            
//                            contact.pinyin = [PinYinForObjc chineseConvertToPinYin:contact.name];
//                            contact.pinyinFirstLetter = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                            
                            contact.tel = formatedTel;
                            [contactsTemp addObject:contact];
                        }
                        break;
                    }
                    case 1: {// Email
                        //contact.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    if (allPeople) CFRelease(allPeople);
    self.noSortContactArray = contactsTemp;
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    // Thanks Steph-Fongo!
    SEL sorter = ABPersonGetSortOrdering() == kABPersonSortByFirstName ? NSSelectorFromString(@"sorterFirstName") : NSSelectorFromString(@"sorterLastName");
    
    for (TKContact *contact in contactsTemp) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:sorter];
        contact.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (TKContact *contact in contactsTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    NSMutableArray *tmpList = [NSMutableArray array];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:sorter];
        [tmpList addObject:sortedSection];
    }
    if (addressBooks) {
        CFRelease(addressBooks);
    }
    
    self.contactArray = tmpList;
    
//    @synchronized(self){
//        [[NSNotificationCenter defaultCenter] postNotificationName:AdressbookLoadFinishedNotification object:nil];
//    }
}

@end
