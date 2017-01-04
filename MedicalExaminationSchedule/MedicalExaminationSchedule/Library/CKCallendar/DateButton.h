//
//  DateButton.h
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 1/4/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CKDateItem *dateItem;
@property (nonatomic, strong) NSCalendar *calendar;

@end
