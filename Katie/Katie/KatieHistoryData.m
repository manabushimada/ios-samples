//
//  KatieHistoryData.m
//  
//
//  Created by manabu shimada on 31/01/2016.
//
//

#import "KatieHistoryData.h"

#import "KatieAppConstants.h"

@implementation KatieHistoryData

// Insert code here to add functionality to your managed object subclass

- (NSDictionary *)dictionaryRepresentation
{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    if (self.calledAt) {
        [dic setObject:self.calledAt forKey:kKatieHistoryCalledAtKey];
    }
    
    if (self.dummyCarrier) {
        [dic setObject:self.dummyCarrier forKey:kKatieHistoryDummyCarrierKey];
    }
    
    if (self.carrier) {
        [dic setObject:self.carrier forKey:kKatieHistoryCarrierKey];
    }
    
    if (self.phoneNumberCalled) {
        [dic setObject:self.phoneNumberCalled forKey:kKatieHistoryPhoneNumberCalledKey];
    }

    if (self.contactNameCalled) {
        [dic setObject:self.contactNameCalled forKey:kKatieHistoryContactNameCalledKey];
    }
    
    if (self.receivedAt) {
        [dic setObject:self.receivedAt forKey:kKatieHistoryReceivedAtKey];
    }
    
    if (self.carrierColor) {
        [dic setObject:self.carrierColor forKey:kKatieHistoryCarrierColorKey];
    }
    
    if (self.phoneNumbers) {
        [dic setObject:self.carrierColor forKey:kKatieHistoryPhoneNumbersKey];
    }
    
    if (self.phoneNumberReceived) {
        [dic setObject:self.phoneNumberReceived forKey:kKatieHistoryPhoneNumberReceivedKey];
    }
    
    return dic;
}


@end
