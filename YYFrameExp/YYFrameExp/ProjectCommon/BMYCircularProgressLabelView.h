//
//  BMYCircularProgressViewNew.h
//  jimao
//
//  Created by fwr on 15/3/30.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMYProgressViewProtocol.h"

@interface BMYCircularProgressLabelView : UIView<BMYProgressViewProtocol>

- (id)initWithFrame:(CGRect)frame
logo:(UIImage *)logoImage
backCircleImage:(UIImage *)backCircleImage
frontCircleImage:(UIImage *)frontCircleImage
        updateLabelString:(NSString *)updateLabelstring
          loadLabel:(NSString *)loadLabelString;


@end
