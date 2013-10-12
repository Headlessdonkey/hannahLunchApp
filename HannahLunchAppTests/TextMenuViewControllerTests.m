//
//  TextMenuViewControllerTests.m
//  HannahLunchApp
//
//  Created by Matt Hayes on 10/12/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import "TextMenuViewController.h"

#import <XCTest/XCTest.h>

@interface TextMenuViewControllerTests : XCTestCase
@property (nonatomic, strong) TextMenuViewController *_sut;
@end

@implementation TextMenuViewControllerTests

- (void)setUp
{
    [super setUp];
    self._sut = [[TextMenuViewController alloc] init];
}

- (void)tearDown
{
    self._sut = nil;
    [super tearDown];
}

- (void)testViewOutlet
{
    assertThat(self._sut.view, is(notNilValue()));
}

- (void)testMenuTableViewOutlet
{
    assertThat(self._sut.view, is(notNilValue()));`
}

@end
