//
//  UITextField+InputCheck.m
//  HealthFriends
//
//  Created by zhoupan on 15/6/11.
//  Copyright (c) 2015年 pan chow. All rights reserved.
//

#import "UITextField+InputCheck.h"
#import "CommonHelper.h"
#import "RegExHelper.h"

#import <objc/runtime.h>
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "NSObject_Swizzle.h"
NSString *const ZP_tftype_mobile = @"ZP_tftype_mobile";
NSString *const ZP_tftype_pwd = @"ZP_tftype_pwd";
NSString *const ZP_tftype_confirmPwd = @"ZP_tftype_confirmPwd";
NSString *const ZP_tftype_authcode = @"ZP_tftype_authcode";

static const void *textFiledTypeKey = &textFiledTypeKey;
@implementation UITextField (InputCheck)

#pragma mark ======  property  ======
- (void)setTextFiledType:(NSString *)textFiledType
{
    [self bk_associateValue:textFiledType withKey:textFiledTypeKey];
}
- (NSString *)textFiledType
{
    return [self bk_associatedValueForKey:textFiledTypeKey];
}
#pragma mark ======  settings  ======
- (void)settingWithType:(NSString *)type
{
    self.textFiledType = type;

    if([type isEqualToString:ZP_tftype_pwd] || [type isEqualToString:ZP_tftype_confirmPwd])
    {
        self.secureTextEntry = YES;
    }
    else 
    {
        self.secureTextEntry = NO;
        
        if([type isEqualToString:ZP_tftype_mobile])
        {
            self.keyboardType = UIKeyboardTypePhonePad;
            self.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
    
    __weak typeof(self)weakSelf = self;
    self.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^(UITextField *tf, NSRange range, NSString *replacement){
        __strong typeof(weakSelf)StrongSelf = weakSelf;
        
        NSString *type = tf.textFiledType;
        
        if([type isEqualToString:ZP_tftype_mobile])
        {
            [StrongSelf mobileTF_changeCharactersInRangeWithReplacementString:tf range:range replacement:replacement];
        }
        else
        {
            
            return YES;
        }
        
        return NO;
    };
}

- (NSString *)trimString
{
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)clearStringWithWhiteSpace
{
    return [self clearStringWithFormats:@[@" "]];
    
}

- (BOOL)isEmpty
{
    return [CommonHelper stringIsEmpty:self.text];
}
- (BOOL)isMobile
{
    if([self isEmpty])
    {
        return NO;
    }
    NSString *string = self.text;
    if(self.textFiledType == ZP_tftype_mobile)
    {
        string = [self clearStringWithWhiteSpace];
    }
    return [RegExHelper isMatchPhone:string];
}
- (BOOL)isPwd
{
    if([self isEmpty])
    {
        return NO;
    }
    return [self checkPwd:self.text];
}
- (BOOL)is_Number//整数
{
    if([self isEmpty])
    {
        return NO;
    }
    return [RegExHelper isMatch_num_Code:self.text];
}
- (BOOL)is_Pos_Number//正整数
{
    if([self isEmpty])
    {
        return NO;
    }
    return [RegExHelper isMatchAct_num_Code:self.text];
}
- (BOOL)is_charactor_Number//字母、数字或组合
{
    if([self isEmpty])
    {
        return NO;
    }
    return [RegExHelper isMatchNormalCharacter:self.text];
}
#pragma mark ======  private  ======
- (BOOL)checkPwd:(NSString *)pwd
{
    NSString *pwdString = [CommonHelper trimString:pwd];
    NSUInteger length = pwdString.length;
    if(length<MIN_NUM || length>MAX_NUM)
    {
        return NO;
    }
    return YES;
}
- (NSString *)clearStringWithFormats:(NSArray *)anArray
{
    if([self isEmpty])
    {
        return @"";
    }
    NSMutableString *tmpMutableStr=[NSMutableString stringWithString:[self trimString]];
    NSArray *deleteArray=[NSArray arrayWithArray:anArray];
    
    NSInteger count=[deleteArray count];
    for(int i=0;i<count;i++)
    {
        NSRange range=[tmpMutableStr rangeOfString:[deleteArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            [tmpMutableStr replaceOccurrencesOfString: [deleteArray objectAtIndex:i]
                                           withString: @""
                                              options: NSLiteralSearch
                                                range: NSMakeRange(0, [tmpMutableStr length])];
        }
    }
    return tmpMutableStr;
    
}
#pragma mark ======  mobile_tf  ======
- (BOOL)mobileTF_changeCharactersInRangeWithReplacementString:(UITextField *)tf range:(NSRange)range replacement:(NSString *)replceString
{
    NSString *text = tf.text;
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    replceString = [replceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([replceString rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:tf];
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:replceString];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    
    NSInteger divIndex = 3;
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, divIndex)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == divIndex) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, divIndex)];
        divIndex = 4;
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 14) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:tf];
        return YES;
    }
    
    [tf setText:newString];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:tf];
    return NO;
}

@end
