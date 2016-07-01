//
//  TKContact.h
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import "TKContact.h"

@implementation TKContact
@synthesize name, email, tel, thumbnail, recordID, sectionNumber, rowSelected, lastName, firstName;

- (NSString*)sorterFirstName {
    if (nil != firstName && ![firstName isEqualToString:@""]) {
        return firstName;
    }
    if (nil != lastName && ![lastName isEqualToString:@""]) {
        return lastName;
    }
    if (nil != name && ![name isEqualToString:@""]) {
        return name;
    }
    return @"";
}

- (NSString*)sorterLastName {
    if (nil != lastName && ![lastName isEqualToString:@""]) {
        return lastName;
    }
    if (nil != firstName && ![firstName isEqualToString:@""]) {
        return firstName;
    }
    if (nil != name && ![name isEqualToString:@""]) {
        return name;
    }
    return @"";
}

@end
