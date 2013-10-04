//
//  UIColor+RandomColor.h
//  uShip
//
//  Created by Jason Pepas on 7/24/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RandomColor)

+ (UIColor*)randomColor;
+ (UIColor*)randomTranslucentColor;
+ (UIColor*)randomTranslucentColorWithAlpha:(float)alpha;

@end
