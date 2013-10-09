//
//  NSString+DayOfWeekForInteger.m
//  HannahLunchAdminApp
//
//  Created by Jason Pepas on 10/8/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "NSString+DayOfWeekForInteger.h"


@implementation NSString (DayOfWeekForInteger)


+ (NSString*)dayOfWeekForInteger:(NSUInteger)anInteger
{
    NSString *dayOfWeek = nil;
    switch (anInteger) {
        case 0:
            dayOfWeek = @"Monday";
            break;
            
        case 1:
            dayOfWeek = @"Tuesday";
            break;
            
        case 2:
            dayOfWeek = @"Wednesday";
            break;
            
        case 3:
            dayOfWeek = @"Thursday";
            break;
            
        case 4:
            dayOfWeek = @"Friday";
            break;
            
        case 5:
            dayOfWeek = @"Saturday";
            break;
            
        case 6:
            dayOfWeek = @"Sunday";
            break;
            
        default:
            break;
    }
    
    return dayOfWeek;
}


@end
