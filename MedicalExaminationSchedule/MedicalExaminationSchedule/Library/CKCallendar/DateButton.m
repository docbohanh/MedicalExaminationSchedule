//
//  DateButton.m
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 1/4/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

#import "DateButton.h"

@implementation DateButton

- (void)setDate:(NSDate *)date {
    _date = date;
    if (date) {
        NSDateComponents *comps = [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:date];
        [self setTitle:[NSString stringWithFormat:@"%d", comps.day] forState:UIControlStateNormal];
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    self.layer.cornerRadius = self.frame.size.width / 2;
}

@end
