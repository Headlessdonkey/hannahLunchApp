//
//  ViewController.m
//  SavingImagesTutorial
//
//  Created by Sidwyn Koh on 29/1/12.
//
//  Photo credits: Stock Exchange (http://www.sxc.hu/)

#import "ViewController.h"

#import <AFNetworking/AFNetworking.h>

@implementation ViewController

#define PHOTO_NAME @"Current_Menu"
#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 0
#define THUMBNAIL_COLS 1
#define THUMBNAIL_WIDTH 320
#define THUMBNAIL_HEIGHT 396

#define PUSH_OPTIONS @[@"now",@"in five minutes",@"in ten minutes"]

#pragma mark - Main methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Current Menu";
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - 

- (IBAction)lunchButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Lunch is ready..."
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"now",@"in five minutes",@"in ten minutes",nil];
    
    [actionSheet showInView:self.view];
    
    
    
}

#pragma mark actionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex < [PUSH_OPTIONS count])
    {
        NSString *pushMessage = [NSString stringWithFormat:@"Lunch is ready %@",[PUSH_OPTIONS objectAtIndex:buttonIndex]] ;
        
        PFPush *push = [PFPush push];
        [push setChannel:PUSH_CHANNEL];
        [push setMessage:pushMessage];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
}
@end
