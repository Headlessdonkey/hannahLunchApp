//
//  ViewController.h
//  ParseTest
//
//  Created by Matt Hayes on 7/16/13.
//  Copyright (c) 2013 Matt Hayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"

@interface ViewController : UIViewController<FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
