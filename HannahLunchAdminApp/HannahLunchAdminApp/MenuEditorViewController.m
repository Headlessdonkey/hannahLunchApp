//
//  MenuEditorViewController.m
//  HannahLunchAdminApp
//
//  Created by Jason Pepas on 10/8/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "MenuEditorViewController.h"
#import "MenuEditorCell.h"
#import "NSString+DayOfWeekForInteger.h"
#import <Parse/Parse.h>
#import "UIAlertView+ShowAlert.h"

@interface MenuEditorViewController ()
{
    NSMutableArray *tableCells;
}

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

    self.tableView.allowsSelection = NO;
}


- (void)_fillTableCellsArray
{
    tableCells = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++) {
        MenuEditorCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MenuEditorCell reuseIdentifier]];
        if (cell == nil)
        {
            cell = [[MenuEditorCell alloc] init];
        }
    
        cell.dayOfWeekLabel.text = [[NSString dayOfWeekForInteger:i] capitalizedString];
        [tableCells addObject:cell];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!tableCells)
    {
        [self _fillTableCellsArray];
    }
    
    return [tableCells objectAtIndex:indexPath.row];
}

- (IBAction)pullCurrentMenu:(id)sender
{
    PFQuery *menuQuery = [PFQuery queryWithClassName:@"MenuForm"];
    [menuQuery orderByDescending:@"createdAt"];
    menuQuery.limit = 1;
    
    [menuQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            if([objects count] > 0)
            {
                PFObject *formAsObject = [objects objectAtIndex:0];
                
                NSError* parsingError = nil;
                NSString *theText = [formAsObject objectForKey:@"form"];
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:[theText dataUsingEncoding:NSUTF8StringEncoding]
                                      options:kNilOptions
                                      error:&parsingError];
                NSLog(@"%@",theText);
                
                NSArray *lunches = [self _fillLunchesArray:json];
                
                [self _populateCellsWithArray:lunches];
                
                [self.tableView reloadData];
                
            }
            else
            {
                [self _showError:@"something sent wrong"];
            }
        }
        else
        {
            [self _showError:error.localizedDescription];
        }
        
    }];
}

- (NSArray*)_fillLunchesArray:(NSDictionary*)dict
{
    NSMutableArray *_lunches = [[NSMutableArray alloc] init];
    
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"monday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"tuesday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"wednesday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"thursday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"friday" fromDictionary:dict]];
    
    return _lunches;
}

- (NSDictionary*)_dictionaryForDayOfTheWeek:(NSString*)dayOfTheWeek fromDictionary:(NSDictionary*)dict
{
    NSString *mainKey = [NSString stringWithFormat:@"%@.main",dayOfTheWeek];
    NSString *sidesKey = [NSString stringWithFormat:@"%@.sides",dayOfTheWeek];
    
    NSString *mainDish = [dict objectForKey:mainKey];
    NSString *sideDish = [dict objectForKey:sidesKey];
    NSDictionary *menuForDay = @{};
    if (dayOfTheWeek.length > 0 && mainDish.length > 0 && sideDish.length > 0)
    {
        menuForDay = @{@"dayOfTheWeek": [dayOfTheWeek uppercaseString],
                       @"mainDish": [dict objectForKey:mainKey],
                       @"sides": [dict objectForKey:sidesKey]};
    }
    
    return menuForDay;
}

- (void)_populateCellsWithArray:(NSArray*)lunches
{
    for (int i = 0; i < [lunches count]; i++) {
        MenuEditorCell *cell = [tableCells objectAtIndex:i];
        NSString *mainKey = @"mainDish";
        NSString *sidesKey = @"sides";
        NSString *mainDish = [(NSDictionary*)[lunches objectAtIndex:i] objectForKey:mainKey];
        NSString *sideDish = [(NSDictionary*)[lunches objectAtIndex:i] objectForKey:sidesKey];
        cell.mainDishTextField.text = mainDish;
        cell.sideDishesTextField.text = sideDish;
    }
}

- (void)_showError:(NSString*)errorMessage
{
    [UIAlertView showAlertWithTitle:@"There was an error pulling the newest image" message:errorMessage];
}


- (IBAction)commitButtonPressed:(id)sender
{
    PFObject *objectToSend = [PFObject objectWithClassName:@"MenuForm"];
    NSDictionary *dictionary = [self _buildDictionary];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
        PFACL *acl = [PFACL ACL];
        [acl setPublicReadAccess:YES];
        
        [objectToSend setACL:acl];
        
        [objectToSend setObject:jsonString forKey:@"form"];
        
        [objectToSend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent!"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil];
                [alert show];
                NSLog(@"Success");
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                message:@"There was a problem sending the message"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil];
                [alert show];
                NSLog(@"%@",error);
            }
        }];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDictionary*)_buildDictionary
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        NSString *dayOftheWeek = [NSString dayOfWeekForInteger:i];
        NSString *mainKey = [NSString stringWithFormat:@"%@.main",dayOftheWeek];
        NSString *sideKey = [NSString stringWithFormat:@"%@.sides",dayOftheWeek];
        MenuEditorCell *cell = [tableCells objectAtIndex:i];
        if (cell.mainDishTextField.text.length > 0 && cell.sideDishesTextField.text.length > 0)
        {
            [dict setObject:cell.mainDishTextField.text forKey:mainKey];
            [dict setObject:cell.sideDishesTextField.text forKey:sideKey];
        }
    }
    
    return dict;
}

@end
