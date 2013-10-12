//
//  ViewControllerTests.m
//  HannahLunchAdminApp
//
//  Created by Matt Hayes on 10/12/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "ViewController.h"

#import <XCTest/XCTest.h>

@interface ViewControllerTests : XCTestCase
@property (nonatomic, strong) ViewController *_sut;
@end

@implementation ViewControllerTests

- (void)setUp
{
    [super setUp];
    self._sut = [[ViewController alloc] init];
}

- (void)tearDown
{
    self._sut = nil;
    [super tearDown];
}

- (void)testViewOutlet
{

}

@end
