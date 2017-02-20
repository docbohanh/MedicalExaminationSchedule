//
//  CALayer+Extension.m
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/7/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

#import "CALayer+Extension.h"
#import <UIKit/UIKit.h>

@implementation CALayer (Extension)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
