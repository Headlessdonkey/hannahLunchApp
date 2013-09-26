//
//  ViewController.m
//  ParseTest
//
//  Created by Matt Hayes on 7/16/13.
//  Copyright (c) 2013 Matt Hayes. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <dispatch/dispatch.h>

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//        [testObject setObject:@"bar" forKey:@"foo"];
//        [testObject save];
//        
//        NSLog(@"parse test object saved");
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
