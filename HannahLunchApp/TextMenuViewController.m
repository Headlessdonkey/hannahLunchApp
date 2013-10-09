//
//  TextMenuViewController.m
//  Test_util
//
//  Created by James Logan on 9/28/13.
//  Copyright (c) 2013 James Logan. All rights reserved.
//

#import "TextMenuViewController.h"
#import <Parse/Parse.h>
#import "UIAlertView+ShowAlert.h"
#import "UIColor+RandomColor.h"
#import "NSDate+WeekdayName.h"

@interface TextMenuViewController ()

@end

@implementation TextMenuViewController
{
    NSMutableArray *_lunches;
}

- (void)awakeFromNib
{
    //self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self _getCurrentMenu];
    self.menuTableView.delegate=self;
    self.menuTableView.dataSource=self;
    
    self.menuTableView.backgroundColor = [UIColor clearColor];
}

- (void)_getCurrentMenu
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
                
                [self _fillLunchesArray:json];
                
                [[self menuTableView] reloadData];
                
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

- (void)_fillLunchesArray:(NSDictionary*)dict
{
    _lunches = [[NSMutableArray alloc] init];
    
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"monday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"tuesday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"wednesday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"thursday" fromDictionary:dict]];
    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"friday" fromDictionary:dict]];
}

- (NSDictionary*)_dictionaryForDayOfTheWeek:(NSString*)dayOfTheWeek fromDictionary:(NSDictionary*)dict
{
    NSString *mainKey = [NSString stringWithFormat:@"%@.main",dayOfTheWeek];
    NSString *sidesKey = [NSString stringWithFormat:@"%@.sides",dayOfTheWeek];
    
    NSDictionary *menuForDay = @{@"dayOfTheWeek": [dayOfTheWeek uppercaseString],
                                 @"mainDish": [dict objectForKey:mainKey],
                                 @"sides": [dict objectForKey:sidesKey]};
    
    return [[NSDictionary alloc] initWithDictionary:menuForDay];
    
    return menuForDay;
}

- (void)_showError:(NSString*)errorMessage
{
    [UIAlertView showAlertWithTitle:@"There was an error pulling the newest image" message:errorMessage];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mrk - Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_lunches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DayOfTheWeekCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dayDictionary = [_lunches objectAtIndex:[indexPath row]];
    
    NSString *dayOfTheWeek = [dayDictionary objectForKey:@"dayOfTheWeek"];
    NSString *mainDish = [dayDictionary objectForKey:@"mainDish"];
    NSString *sideDishes = [dayDictionary objectForKey:@"sides"];

    NSString *todayDayOfTheWeek = [[NSDate date] weekdayName];
    BOOL isTodaysCell = [[dayOfTheWeek uppercaseString] isEqualToString:[todayDayOfTheWeek uppercaseString]];
    
    UIColor *labelColor;
    UIColor *secondLabelColor;
    if (isTodaysCell)
    {
        labelColor = [UIColor randomColor];
        secondLabelColor = [UIColor randomColor];
    }
    else
    {
        labelColor = [UIColor whiteColor];
        secondLabelColor = [UIColor whiteColor];
    }
    
    NSString *fontName = @"Eraser";
    
    UILabel *dayLabel = (UILabel *)[cell viewWithTag:100];
    [dayLabel setFont:[UIFont fontWithName:fontName size:18]];
    [dayLabel setTextColor:labelColor];
    
    UILabel *mainDishLabel = (UILabel *)[cell viewWithTag:101];
    [mainDishLabel setFont:[UIFont fontWithName:fontName size:15]];
    [mainDishLabel setTextColor:secondLabelColor];
    
    UILabel *sidesLabel = (UILabel *)[cell viewWithTag:102];
    [sidesLabel setFont:[UIFont fontWithName:fontName size:15]];
    [sidesLabel setTextColor:secondLabelColor];
    
    UILabel *mainTitleLabel = (UILabel *)[cell viewWithTag:103];
    [mainTitleLabel setFont:[UIFont fontWithName:fontName size:15]];
    [mainTitleLabel setTextColor:labelColor];
    
    UILabel *sidesTitleLabel = (UILabel *)[cell viewWithTag:104];
    [sidesTitleLabel setFont:[UIFont fontWithName:fontName size:15]];
    [sidesTitleLabel setTextColor:labelColor];
    
    [dayLabel setText:dayOfTheWeek];
    [mainDishLabel setText:mainDish];
    [sidesLabel setText:sideDishes];
    
    return cell;
}

#pragma mark - Table delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
