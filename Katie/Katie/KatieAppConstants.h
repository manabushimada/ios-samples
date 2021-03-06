//
//  KatieAppConstants.h
//  Katie
//
//  Created by manabu shimada on 24/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#ifndef KatieAppConstants_h
#define KatieAppConstants_h


#define kKatieUnknowPhoneNumber @"unknow phone number"


/*----------------------------------------------------------------------------*
 * CoreData attribute keys for KatieAddressData
 *----------------------------------------------------------------------------*/
static NSString * const kKatieDummyCarrierKey =      @"dummyCarrier";
static NSString * const kKatieCreatedAtKey =         @"createdAt";
static NSString * const kKatieFavouriteKey =         @"favourite";
static NSString * const kKatiePhoneNumbersKey =      @"phoneNumbers";
static NSString * const kKatieMyCarrierKey =         @"myCarrier";
static NSString * const kKatieMyNameKey =            @"myName";
static NSString * const kKatieMyPhoneNumberKey =     @"myPhoneNumber";
static NSString * const kKatieContactNameKey =       @"contactName";
static NSString * const kKatieCarrierKey =           @"carrier";
static NSString * const kKatieCountryCodeKey =       @"countryCode";
static NSString * const kKatieNationalFormatKey =    @"nationalFormat";
static NSString * const kKatiePhoneNumberKey =       @"phoneNumber";
static NSString * const kKatieUrlKey =               @"url";
static NSString * const kKatieCarrierColorKey =      @"carrierColor";

/*----------------------------------------------------------------------------*
 * CoreData attribute keys for KatieHistoryData
 *----------------------------------------------------------------------------*/
static NSString * const kKatieHistoryCalledAtKey =          @"calledAt";
static NSString * const kKatieHistoryDummyCarrierKey =      @"dummyCarrier";
static NSString * const kKatieHistoryPhoneNumberCalledKey = @"phoneNumberCalled";
static NSString * const kKatieHistoryPhoneNumberReceivedKey = @"phoneNumberReceived";
static NSString * const kKatieHistoryPhoneNumbersKey =      @"phoneNumbers";
static NSString * const kKatieHistoryContactNameCalledKey = @"contactNameCalled";
static NSString * const kKatieHistoryReceivedAtKey =        @"receivedAt";
static NSString * const kKatieHistoryCarrierKey =           @"carrier";
static NSString * const kKatieHistoryCarrierColorKey =      @"carrierColor";


/*----------------------------------------------------------------------------*
 * Twilio Lookup Setup keys
 *----------------------------------------------------------------------------*/
#define kTwilioLookupAccountSidKey @"AC3e6c408a2c6385fb1a2548fef384a453"
#define kTwilioLookupAuthTokenKey @"618959268c1d02779c0017629a491020"
#define kTwilioLookupResourceURL @"https://lookups.twilio.com/v1/PhoneNumbers/"

/*----------------------------------------------------------------------------*
 * Twilio Lookup REST API Keys
 *----------------------------------------------------------------------------*/
#define kTwilioLookupCountryCodeKey @"country_code"
#define kTwilioLookupPhoneNumberKey @"phone_number"
#define kTwilioLookupNationalFormatKey @"national_format"
#define kTwilioLookupUrlKey @"url"
#define kTwilioLookupCarrierKey @"carrier"
#define kTwilioLookupCarrierTypeKey @"type"
#define kTwilioLookupCarrierErrorCodeKey @"error_code"
#define kTwilioLookupCarrierMobileNetworkCodeKey @"mobile_network_code"
#define kTwilioLookupCarrierMobileCountryCodeKey @"mobile_country_code"
#define kTwilioLookupCarrierNameKey @"name"

/*----------------------------------------------------------------------------*
 * Flurry applications Keys
 *----------------------------------------------------------------------------*/
#define kFlurryApplicationKey @"34MQPJH9G847YQZWK8C3"

#endif /* KatieAppConstants_h */
