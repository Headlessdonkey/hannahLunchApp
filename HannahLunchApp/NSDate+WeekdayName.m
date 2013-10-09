//
//  NSDate+WeekdayName.m
//  HannahLunchApp
//
//  Created by Matt Hayes on 10/8/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "NSDate+WeekdayName.h"

@implementation NSDate (WeekdayName)

- (NSString*)weekdayName
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:self];
    NSInteger weekday = [weekdayComponents weekday];
    NSString *todayDayOfTheWeek;
    switch (weekday) {
        case 1:
            todayDayOfTheWeek = @"Sunday";
            break;
        case 2:
            todayDayOfTheWeek = @"Monday";
            break;
        case 3:
            todayDayOfTheWeek = @"Tuesday";
            break;
        case 4:
            todayDayOfTheWeek = @"Wednesday";
            break;
        case 5:
            todayDayOfTheWeek = @"Thursday";
            break;
        case 6:
            todayDayOfTheWeek = @"Friday";
            break;
        case 7:
            todayDayOfTheWeek = @"Saturday";
            break;
        default:
            todayDayOfTheWeek = @"Unknown";
            break;
    }
    return todayDayOfTheWeek;
}
@end
