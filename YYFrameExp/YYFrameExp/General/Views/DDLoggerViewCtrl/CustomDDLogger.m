//
//  CustomDDLogger.m
//  jimao
//
//  Created by pan chow on 15/4/23.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "CustomDDLogger.h"

@implementation CustomDDLogger

- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *logMsg = logMessage.message;
    
    if (self->_logFormatter)
        logMsg = [self->_logFormatter formatLogMessage:logMessage];
    
    if (logMsg) {
        // Write logMsg to wherever...
    }
}


@end
