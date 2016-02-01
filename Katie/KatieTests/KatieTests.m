//
//  KatieTests.m
//  KatieTests
//
//  Created by manabu shimada on 24/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KatieDataManager.h"
#import "KatieNetworkManager.h"

@interface KatieTests : XCTestCase

@end

@implementation KatieTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNewAddressData
{
    KatieAddressData *data = [KatieDataManager newAddressData];
    [data setCreatedAt:[NSDate date]];
    [data setContactName:@"NewAddressDataTest"];
    [data setCarrierColor:@"000000"];
    [data setCountryCode:@"JP"];
    [data setDummyCarrier:@"Vodafone"];
    [data setPhoneNumber:@"+442076130433"];
    [KatieDataManager save];
    
    XCTAssertNotNil(data);
    XCTAssertTrue([data.createdAt isKindOfClass:[NSDate class]]);
    XCTAssertTrue([data.contactName isKindOfClass:[NSString class]]);
    XCTAssertTrue([data.carrierColor isKindOfClass:[NSString class]]);
    XCTAssertTrue([data.countryCode isKindOfClass:[NSString class]]);
    XCTAssertTrue([data.dummyCarrier isKindOfClass:[NSString class]]);
    XCTAssertTrue([data.phoneNumber isKindOfClass:[NSString class]]);
}

- (void)testDictinaryRepresentation
{
    KatieAddressData *data = [KatieDataManager newAddressData];
    [data setCreatedAt:[NSDate date]];
    [data setContactName:@"DictinaryRepresentationTest"];
    [data setCarrierColor:@"111111"];
    [data setCountryCode:@"UK"];
    [data setDummyCarrier:@"EE"];
    [data setPhoneNumber:@"00442076130433"];
    [KatieDataManager save];
    
    KatieAddressData *savedData = [KatieDataManager katieAddressDataForContactName:data.contactName];
    
    XCTAssertNotNil(savedData);
    XCTAssertTrue([[savedData dictionaryRepresentation] isKindOfClass:[NSDictionary class]]);
}


@end
