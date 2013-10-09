//
//  MenuEditorCell.m
//  HannahLunchAdminApp
//
//  Created by Jason Pepas on 10/8/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "MenuEditorCell.h"

@implementation MenuEditorCell


- (void)awakeFromNib
{
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(_cellWasTapped:)];
    [self addGestureRecognizer:recognizer];
}


- (void)_cellWasTapped:(id)sender
{
    [self _hideKeyboardWhenUserTapsOutsideOfATextField];
}


- (void)_hideKeyboardWhenUserTapsOutsideOfATextField
{
    [self endEditing:YES];
}


+ (NSString*)reuseIdentifier
{
    return [[self class] description];
}


@end
