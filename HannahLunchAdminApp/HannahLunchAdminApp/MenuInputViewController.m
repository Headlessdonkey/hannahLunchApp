//
//  MenuInputViewController.m
//  HannahLunchAdminApp
//
//  Created by Matt Hayes on 10/4/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "MenuInputViewController.h"

#import <Parse/Parse.h>

@interface MenuInputViewController ()

@end

@implementation MenuInputViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _getCurrentMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                [self _fillLunchesArray:json];
                
//                [[self menuTableView] reloadData];
                
            }
            else
            {
//                [self _showError:@"Collection of images was empty"];
            }
        }
        else
        {
//            [self _showError:error.localizedDescription];
        }
        
    }];
}

- (void)_fillLunchesArray:(NSDictionary*)dict
{
//    _lunches = [[NSMutableArray alloc] init];
//    
//    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"monday" fromDictionary:dict]];
//    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"tuesday" fromDictionary:dict]];
//    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"wednesday" fromDictionary:dict]];
//    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"thursday" fromDictionary:dict]];
//    [_lunches addObject:[self _dictionaryForDayOfTheWeek:@"friday" fromDictionary:dict]];
}

@end
