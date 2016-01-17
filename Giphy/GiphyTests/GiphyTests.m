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
    [AXCGiphy setGiphyAPIKey:kGiphyPublicAPIKey];
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
