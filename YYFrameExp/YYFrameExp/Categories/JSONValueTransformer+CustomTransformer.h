//
//  JSONValueTransformer+CustomTransformer.h
//  jimao
//
//  Created by pan chow on 14/12/1.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string;
- (NSString *)JSONObjectFromNSDate:(NSDate *)date;

@end
