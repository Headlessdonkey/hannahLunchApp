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
    allImages = [[NSMutableArray alloc] init];
    self.title = @"Current Menu";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
}

- (IBAction)refresh:(id)sender
{
    NSLog(@"Showing Refresh HUD");
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:PHOTO_NAME];
    query.limit = 1;
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            if (refreshHUD)
            {
                [refreshHUD hide:YES];
                
                refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:refreshHUD];
                
                // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
                // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
                refreshHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                refreshHUD.mode = MBProgressHUDModeCustomView;
                
                refreshHUD.delegate = self;
            }
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            // Retrieve existing objectIDs

            NSMutableArray *oldCompareObjectIDArray = [NSMutableArray array];
            for (UIView *view in [photoScrollView subviews])
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *eachButton = (UIButton *)view;
                    [oldCompareObjectIDArray addObject:[eachButton titleForState:UIControlStateReserved]];
                }
            }
                        
            NSMutableArray *oldCompareObjectIDArray2 = [NSMutableArray arrayWithArray:oldCompareObjectIDArray];
            
            // If there are photos, we start extracting the data
            // Save a list of object IDs while extracting this data
            
            NSMutableArray *newObjectIDArray = [NSMutableArray array];            
            if (objects.count > 0)
            {
                for (PFObject *eachObject in objects)
                {
                    [newObjectIDArray addObject:[eachObject objectId]];
                }
            }
            
            // Compare the old and new object IDs
            NSMutableArray *newCompareObjectIDArray = [NSMutableArray arrayWithArray:newObjectIDArray];
            NSMutableArray *newCompareObjectIDArray2 = [NSMutableArray arrayWithArray:newObjectIDArray];
            if (oldCompareObjectIDArray.count > 0)
            {
                // New objects
                [newCompareObjectIDArray removeObjectsInArray:oldCompareObjectIDArray];
                // Remove old objects if you delete them using the web browser
                [oldCompareObjectIDArray removeObjectsInArray:newCompareObjectIDArray2];
                if (oldCompareObjectIDArray.count > 0)
                {
                    // Check the position in the objectIDArray and remove
                    NSMutableArray *listOfToRemove = [[NSMutableArray alloc] init];
                    for (NSString *objectID in oldCompareObjectIDArray)
                    {
                        int i = 0;
                        for (NSString *oldObjectID in oldCompareObjectIDArray2)
                        {
                            if ([objectID isEqualToString:oldObjectID])
                            {
                                // Make list of all that you want to remove and remove at the end
                                [listOfToRemove addObject:[NSNumber numberWithInt:i]];
                            }
                            i++;
                        }
                    }
                    
                    // Remove from the back
                    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
                    [listOfToRemove sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
                    
                    for (NSNumber *index in listOfToRemove)
                    {
                        [allImages removeObjectAtIndex:[index intValue]];
                    }
                }
            }
            
            // Add new objects
            for (NSString *objectID in newCompareObjectIDArray)
            {
                for (PFObject *eachObject in objects)
                {
                    if ([[eachObject objectId] isEqualToString:objectID])
                    {
                        NSMutableArray *selectedPhotoArray = [[NSMutableArray alloc] init];
                        [selectedPhotoArray addObject:eachObject];
                                                
                        if (selectedPhotoArray.count > 0)
                        {
                            [allImages addObjectsFromArray:selectedPhotoArray];                
                        }
                    }
                }
            }
            
            // Remove and add from objects before this
            [self setUpImages:allImages];
            
        }
        else
        {
            [refreshHUD hide:YES];
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    // Check for camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, you have to use a device with a camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"Aw, shucks"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:PHOTO_NAME data:imageData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading";
    [HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            //Hide determinate HUD
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;

            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:PHOTO_NAME];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACL];
            [userPhoto.ACL setPublicReadAccess:YES];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (!error)
                {
                    [self refresh:nil];
                }
                else
                {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else
        {
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone)
    {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
}

- (void)setUpImages:(NSArray *)images
{
    // Contains a list of all the BUTTONS
    allImages = [images mutableCopy];
    
    // This method sets up the downloaded images and places them nicely in a grid
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *imageDataArray = [NSMutableArray array];
        
        // Iterate over all images and get the data from the PFFile
        for (int i = 0; i < images.count; i++)
        {
            PFObject *eachObject = [images objectAtIndex:i];
            PFFile *theImage = [eachObject objectForKey:@"imageFile"];
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [imageDataArray addObject:image];
        }
                   
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // Remove old grid
            for (UIView *view in [photoScrollView subviews])
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    [view removeFromSuperview];
                }
            }
            
            // Create the buttons necessary for each image in the grid
            for (int i = 0; i < [imageDataArray count]; i++)
            {
                PFObject *eachObject = [images objectAtIndex:i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *image = [imageDataArray objectAtIndex:i];
                [button setImage:image forState:UIControlStateNormal];
                button.tag = i;
                button.frame = CGRectMake(THUMBNAIL_WIDTH * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
                                          THUMBNAIL_HEIGHT * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
                                          THUMBNAIL_WIDTH,
                                          THUMBNAIL_HEIGHT);
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [button setTitle:[eachObject objectId] forState:UIControlStateReserved];
                [photoScrollView addSubview:button];
            }
            
            // Size the grid accordingly
            int rows = images.count / THUMBNAIL_COLS;
            if (((float)images.count / THUMBNAIL_COLS) - rows != 0)
            {
                rows++;
            }
            int height = THUMBNAIL_HEIGHT * rows + PADDING * rows + PADDING + PADDING_TOP;
            
            photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            photoScrollView.clipsToBounds = YES;
        });
    });
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    [self uploadImage:imageData];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
	HUD = nil;
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
