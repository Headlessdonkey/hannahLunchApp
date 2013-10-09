//
//  UIAlertView+ShowAlert.m
//  uShip
//
//  Created by Jason Pepas on 6/19/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "UIAlertView+ShowAlert.h"

@implementation UIAlertView (ShowAlert)


+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
}


@end
