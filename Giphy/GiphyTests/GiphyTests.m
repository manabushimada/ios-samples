//
//  GiphyTests.m
//  GiphyTests
//
//  Created by manabu shimada on 17/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "GiphyCollectionViewCell.h"

#define NETWORK_TIMEOUT_DURATION 5

@interface GiphyTests : XCTestCase
@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) GiphyCollectionViewCell *collectionCell;
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

- (void)testGiphyCollectionViewCell
{
    self.collectionCell = [[GiphyCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
}
- (void)testQueryGiphyAPI
{
    [self.viewController queryAXCGiphy:@"test"];
    [self waitForExpectationsWithTimeout:NETWORK_TIMEOUT_DURATION handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testLoadCells
{
    [self.viewController loadCells];
}

@end
