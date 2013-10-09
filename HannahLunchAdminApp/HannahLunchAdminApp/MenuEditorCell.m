//
//  MenuEditorCell.m
//  HannahLunchAdminApp
//
//  Created by Jason Pepas on 10/8/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "MenuEditorCell.h"

@implementation MenuEditorCell


- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:[[self class] reuseIdentifier]];
    if (self == nil)
    {
        return nil;
    }
    return self;
}


+ (NSString*)reuseIdentifier
{
    return [[self class] description];
}


@end
