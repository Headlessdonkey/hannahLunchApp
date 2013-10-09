//
//  MenuEditorViewController.m
//  HannahLunchAdminApp
//
//  Created by Jason Pepas on 10/8/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "MenuEditorViewController.h"
#import "MenuEditorCell.h"


@interface MenuEditorViewController ()

@end



@implementation MenuEditorViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self == nil)
    {
        return nil;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuEditorCell *cell = [tableView dequeueReusableCellWithIdentifier:[MenuEditorCell reuseIdentifier]];
    if (cell == nil)
    {
        cell = [[MenuEditorCell alloc] init];
    }

    cell.dayOfWeekLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];

    return cell;
}


@end
