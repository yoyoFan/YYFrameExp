//
//  MySoundUtil.m
//  FlowExp
//
//  Created by Dongle Su on 14-6-7.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "MySoundUtil.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MySoundUtil{
    SystemSoundID newMessageSoundId_;
}
SINGLETON_GCD(MySoundUtil);

- (void) dealloc {
    AudioServicesDisposeSystemSoundID (newMessageSoundId_);
}

- (SystemSoundID)soundIdWithName:(NSString *)fileName extension:(NSString *)extension{
    SystemSoundID ret;
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: fileName
                                                withExtension: extension];
    
    // Store the URL as a CFURLRef instance
    CFURLRef soundFileURLRef = (__bridge CFURLRef) tapSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &ret
                                      );
    //CFRelease (soundFileURLRef);
    return ret;

}
- (void)playNewMessageSound{
    if (!newMessageSoundId_) {
        newMessageSoundId_ = [self soundIdWithName:@"youhavemessage" extension:@"wav"];
    }
    AudioServicesPlaySystemSound (newMessageSoundId_);
}
- (void)vibrate{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

+ (void)vibrate{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
@end
