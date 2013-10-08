//
//  FlipsideViewController.h
//  Test_util
//
//  Created by James Logan on 9/28/13.
//  Copyright (c) 2013 James Logan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *menuTableView;

- (IBAction)done:(id)sender;

@end
