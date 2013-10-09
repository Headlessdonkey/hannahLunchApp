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
            dayOfWeek = @"monday";
            break;
            
        case 1:
            dayOfWeek = @"tuesday";
            break;
            
        case 2:
            dayOfWeek = @"wednesday";
            break;
            
        case 3:
            dayOfWeek = @"thursday";
            break;
            
        case 4:
            dayOfWeek = @"friday";
            break;
            
        case 5:
            dayOfWeek = @"saturday";
            break;
            
        case 6:
            dayOfWeek = @"sunday";
            break;
            
        default:
            break;
    }
    
    return dayOfWeek;
}


@end
