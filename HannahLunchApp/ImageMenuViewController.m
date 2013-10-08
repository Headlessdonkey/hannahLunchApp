//
//  ImageMenuViewController.m
//  ParseTest
//
//  Created by Matt Hayes on 7/16/13.
//  Copyright (c) 2013 Matt Hayes. All rights reserved.
//

#import "ImageMenuViewController.h"
#import <Parse/Parse.h>
#import <dispatch/dispatch.h>
#import "UIAlertView+ShowAlert.h"

@interface ImageMenuViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@end

@implementation ImageMenuViewController

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
    PFQuery *menuQuery = [PFQuery queryWithClassName:@"Current_Menu"];
    [menuQuery orderByDescending:@"createdAt"];
    menuQuery.limit = 1;
    
    [menuQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            if([objects count] > 0)
            {
                NSLog(@"Successfully retrieved %d photos.", objects.count);
                PFObject *imageAsObject = [objects objectAtIndex:0];
                
                PFFile *theImage = [imageAsObject objectForKey:@"imageFile"];
                NSData *imageData = [theImage getData];
                UIImage *image = [UIImage imageWithData:imageData];
                self.imageView.image = image;
                
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

- (void)_showError:(NSString*)errorMessage
{
    [UIAlertView showAlertWithTitle:@"There was an error pulling the newest image" message:errorMessage];
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(TextMenuViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}


@end
