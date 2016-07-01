//
//  Tip.m
//  FlowExp
//
//  Created by Dongle Su on 14-4-12.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "Tip.h"
#import "MBProgressHud.h"

@implementation Tip
+ (MBProgressHUD *)getCreateHudForView:(UIView *)view{
    if (view == nil) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [hud setRemoveFromSuperViewOnHide:YES];
        [view addSubview:hud];
    }

    return hud;
}
+ (void)tipProgress:(NSString *)msgString OnView:(UIView *)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [Tip getCreateHudForView:superView];
        if (msgString) {
            [hud setLabelText:msgString];
        }
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud setCustomView:nil];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud show:YES];
    });
}
+ (void)tipHideOnView:(UIView*)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = superView;
        if (view == nil) {
            view = [[[UIApplication sharedApplication] delegate] window];
        }

        MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
        if (hud) {
            [hud hide:YES];
        }
    });
}
+ (void)tipImmediateHideOnView:(UIView*)superView{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:superView];
    if (hud) {
        [hud hide:NO];
    }
}

+ (void)showTip:(NSString *)msg OnView:(UIView *)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [Tip getCreateHudForView:superView];
        [hud setMode:MBProgressHUDModeText];
        [hud setCustomView:nil];
        [hud setLabelText:msg];
        [hud show:YES];
    });
}

+ (void)tipMsg:(NSString *)msgString OnView:(UIView *)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [Tip getCreateHudForView:superView];
        [hud setMode:MBProgressHUDModeText];
        [hud setCustomView:nil];
        if (msgString.length > 14) {
            [hud setDetailsLabelText:msgString];
            [hud setLabelText:nil];
        }
        else{
            [hud setLabelText:msgString];
            [hud setDetailsLabelText:nil];
        }
        //[hud setLabelText:msgString];
        [hud show:YES];
        [hud hide:YES afterDelay:2];
    });
    
    NSLog(@"tip msg :%@", msgString);
}

+ (void)tipError:(NSString *)errorString OnView:(UIView *)superView{
    if (errorString.length > 14) {
        [Tip tipErrorTitle:nil detail:errorString OnView:superView];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [Tip getCreateHudForView:superView];
        //[hud setMode:MBProgressHUDModeText];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tipError"]]];
        [hud setLabelText:errorString];
        [hud show:YES];
        [hud hide:YES afterDelay:2];
    });

    NSLog(@"tip error :%@", errorString);
}

+ (void)tipErrorTitle:(NSString *)title detail:(NSString *)detail OnView:(UIView *)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [Tip getCreateHudForView:superView];
        //[hud setMode:MBProgressHUDModeText];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tipError"]]];
        [hud setLabelText:title];
        [hud setDetailsLabelText:detail];
        [hud show:YES];
        [hud hide:YES afterDelay:2];
    });
    
    NSLog(@"tip error title:%@, detail:%@", title, detail);
}

+ (void)tipSuccess:(NSString *)msg OnView:(UIView *)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [Tip getCreateHudForView:superView];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tipSuccess"]]];
        //[hud setLabelText:msg];
        if (msg.length > 14) {
            [hud setDetailsLabelText:msg];
            [hud setLabelText:nil];
        }
        else{
            [hud setLabelText:msg];
            [hud setDetailsLabelText:nil];
        }

        [hud show:YES];
        [hud hide:YES afterDelay:2];
    });
    
    NSLog(@"tip success :%@", msg);
}
@end
