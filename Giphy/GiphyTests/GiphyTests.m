//
//  GiphyTests.m
//  GiphyTests
//
//  Created by manabu shimada on 17/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

#define NETWORK_TIMEOUT_DURATION 5

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
     XCTestExpectation *expectation = [self expectationWithDescription:@"fetch results from giphy api"];
    
    ;
    XCTAssertNotNil(self.viewController.giphyResults, @"fetched");
    [expectation fulfill];
    
    
    [self waitForExpectationsWithTimeout:NETWORK_TIMEOUT_DURATION handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

- (void)testCreateButtons
{
    [self.viewController createCategoriesButtons];
    XCTAssertNotNil(self.viewController.categoriesButtons, @"created");
}
@end
