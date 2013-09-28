//
//  FlipsideViewController.m
//  Test_util
//
//  Created by James Logan on 9/28/13.
//  Copyright (c) 2013 James Logan. All rights reserved.
//

#import "FlipsideViewController.h"
#import <Parse/Parse.h>
#import "UIAlertView+ShowAlert.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

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
                NSLog(@"Successfully retrieved %d photos.", objects.count);
                PFObject *formAsObject = [objects objectAtIndex:0];
                
                NSError* parsingError = nil;
                NSString *theText = [formAsObject objectForKey:@"form"];
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:[theText dataUsingEncoding:NSUTF8StringEncoding]
                                      options:kNilOptions 
                                      error:&parsingError];
                NSLog(@"%@",theText);
                
                self.menuView.text = [self _displayStringFromDictionary:json];
                
            }
            else
            {
                [self _showError:@"Collection of images was empty"];
            }
        }
        else
        {
            [self _showError:error.localizedDescription];
        }
        
    }];
}

- (NSString*)_displayStringFromDictionary:(NSDictionary*)dict
{
    NSMutableString *displayString = [[NSMutableString alloc] initWithString:@""];
    
    [displayString appendString:[self _stringForDayOfTheWeek:@"monday" fromDictionary:dict]];
    [displayString appendString:[self _stringForDayOfTheWeek:@"tuesday" fromDictionary:dict]];
    [displayString appendString:[self _stringForDayOfTheWeek:@"wednesday" fromDictionary:dict]];
    [displayString appendString:[self _stringForDayOfTheWeek:@"thursday" fromDictionary:dict]];
    [displayString appendString:[self _stringForDayOfTheWeek:@"friday" fromDictionary:dict]];
    return displayString;
}

- (NSString*)_stringForDayOfTheWeek:(NSString*)dayOfTheWeek fromDictionary:(NSDictionary*)dict
{
    NSMutableString *displayString = [[NSMutableString alloc] initWithString:@""];
    
    NSString *mainKey = [NSString stringWithFormat:@"%@.main",dayOfTheWeek];
    NSString *sidesKey = [NSString stringWithFormat:@"%@.sides",dayOfTheWeek];
    
    [displayString appendString:[dayOfTheWeek uppercaseString]];
    [displayString appendString:@"\n"];
    [displayString appendString:@"Main Dish: "];
    [displayString appendString:[dict objectForKey:mainKey]];
    [displayString appendString:@"\n"];
    [displayString appendString:@"Sides: "];
    [displayString appendString:[dict objectForKey:sidesKey]];
    [displayString appendString:@"\n"];
    [displayString appendString:@"\n"];
    
    return displayString;
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

@end
