//
//  KatieAddressData.m
//  
//
//  Created by manabu shimada on 31/01/2016.
//
//

#import "KatieAddressData.h"

#import "KatieAppConstants.h"

@implementation KatieAddressData

// Insert code here to add functionality to your managed object subclass
- (NSDictionary *)dictionaryRepresentation
{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    if (self.createdAt) {
        [dic setObject:self.createdAt forKey:kKatieCreatedAtKey];
    }
    
    if (self.dummyCarrier) {
        [dic setObject:self.dummyCarrier forKey:kKatieDummyCarrierKey];
    }
    
    if (self.favourite) {
        [dic setObject:self.favourite forKey:kKatieFavouriteKey];
    }
    
    if (self.phoneNumbers) {
        [dic setObject:self.phoneNumbers forKey:kKatiePhoneNumbersKey];
    }
    
    if (self.myCarrier) {
        [dic setObject:self.myCarrier forKey:kKatieMyCarrierKey];
    }
    
    if (self.myName) {
        [dic setObject:self.myName forKey:kKatieMyNameKey];
    }
    
    if (self.myPhoneNumber) {
        [dic setObject:self.myPhoneNumber forKey:kKatieMyPhoneNumberKey];
    }
    
    if (self.contactName) {
        [dic setObject:self.contactName forKey:kKatieContactNameKey];
    }
    
    if (self.carrier) {
        [dic setObject:self.carrier forKey:kKatieCarrierKey];
    }
    
    if (self.countryCode) {
        [dic setObject:self.countryCode forKey:kKatieCountryCodeKey];
    }
    
    if (self.nationalFormat) {
        [dic setObject:self.nationalFormat forKey:kKatieNationalFormatKey];
    }
    
    if (self.phoneNumber) {
        [dic setObject:self.phoneNumber forKey:kKatiePhoneNumberKey];
    }
    
    if (self.url) {
        [dic setObject:self.url forKey:kKatieUrlKey];
    }
    
    if (self.carrierColor) {
        [dic setObject:self.carrierColor forKey:kKatieCarrierColorKey];
    }
    
    return dic;
}


@end
