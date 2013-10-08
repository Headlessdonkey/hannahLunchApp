//
//  ImageMenuViewController.h
//  ParseTest
//
//  Created by Matt Hayes on 7/16/13.
//  Copyright (c) 2013 Matt Hayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextMenuViewController.h"

@interface ImageMenuViewController : UIViewController<FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
