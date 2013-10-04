//
//  UIColor+RandomColor.m
//  uShip
//
//  Created by Jason Pepas on 7/24/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "UIColor+RandomColor.h"
#import "MathMacros.h"


@implementation UIColor (RandomColor)


+ (UIColor*)randomTranslucentColorWithAlpha:(float)alpha
{
    
    return [UIColor colorWithRed:[self _flooredNumber]
                           green:[self _flooredNumber]
                            blue:[self _flooredNumber]
                           alpha:alpha];
}

+(float)_flooredNumber
{
    float number = NORMALIZED_RANDOM_FLOAT;
    number = number < .3?.3:number;
    return number;
}

+ (UIColor*)randomTranslucentColor
{
    return [UIColor randomTranslucentColorWithAlpha:0.3];
}


+ (UIColor*)randomColor
{
    return [UIColor randomTranslucentColorWithAlpha:1.0];
}


@end
