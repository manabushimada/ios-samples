//
//  GiphyTests.m
//  GiphyTests
//
//  Created by manabu shimada on 17/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface GiphyTests : XCTestCase
@property (nonatomic, strong) ViewController *viewController;
@end

@implementation GiphyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.viewController = [ViewController new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQueryGiphyAPI
{
    XCTAssertNoThrow([self.viewController queryAXCGiphy:@"test"]);
}

@end
