//
//  DataManager.m
//  Katie
//
//  Created by manabu shimada on 25/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "KatieDataManager.h"

#import <UIKit/UIKit.h>
#import <APContact.h>

#import "KatieNetworkManager.h"

static KatieDataManager *sharedMyManager = nil;

@implementation KatieDataManager

+ (KatieDataManager *)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

- (void)initializeCoreData
{
    /*----------------------------------------------------------------------------*
     * IMPORTANT: NSAssert doesn't normally run in Release build.
     * Ref: http://stackoverflow.com/questions/30466374/core-data-not-saving-in-distribution-build
     *----------------------------------------------------------------------------*/
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KatieModel" withExtension:@"momd"];
    
    //NSManagedObjectModel: It is a class that contains definitions for each of the objects (also called “Entities”) that you are storing in the database.
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if (!mom) {
        abort();
    }
    //NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    //  NSPersistentStoreCoordinator: Database connection - set up the actual names and locations of what databases will be used to store the objects
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    //NSManagedObjectContext: get objects, insert objects, or delete objects, you call methods on the managed object context
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"KatieModel.sqlite"];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //NSAssert([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
    
}


+ (BOOL) save {
    
    NSError *error = nil;
    if ([[[KatieDataManager sharedManager] managedObjectContext] save:&error] == NO) {
        //NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
        NSLog(@"Failed to save main context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    return !error; // will never be called atm.
}


+ (KatieAddressData *)newAddressData
{    
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    KatieAddressData *newAddressData = (KatieAddressData *) [NSEntityDescription insertNewObjectForEntityForName:@"KatieAddressData" inManagedObjectContext:moc];
    return newAddressData;
    
}

+ (KatieHistoryData *)newHistoryData
{
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    KatieHistoryData *newHistoryData = (KatieHistoryData *) [NSEntityDescription insertNewObjectForEntityForName:@"KatieHistoryData" inManagedObjectContext:moc];
    return newHistoryData;
    
}

+ (void)registerMyContacts:(NSArray *)contacts
{
    NSArray *fetchedObjects;
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetch = [NSFetchRequest new];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"KatieAddressData" inManagedObjectContext:moc];
    [fetch setEntity:entityDescription];
    
    NSError *error = nil;
    fetchedObjects = [moc executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count == 0)
    {
        /**
        // TODO: Register an user's device
        KatieAddressData *myAddressData = [KatieDataManager newAddressData];
        [myAddressData setMyName:[[UIDevice currentDevice] name]];
        //[myAddressData setMyPhoneNumber:] // Apple doesn't allow us to get my number unfortunately.
        [myAddressData setCreatedAt:[NSDate date]];
        [myAddressData setDummyCarrier:[KatieNetworkManager randomCarrier]];
        [myAddressData setCarrierColor:[KatieNetworkManager carrierColorHex:myAddressData.dummyCarrier]];
        [KatieDataManager save];
        NSLog(@"saved my address");
         */
        
        dispatch_group_t dispatchGroup = dispatch_group_create();
        // For contacts from user's address
        for (APContact *contact in contacts)
        {
            dispatch_group_enter(dispatchGroup);
            KatieAddressData *myContactsData = [KatieDataManager newAddressData];
            [myContactsData setContactName:contact.name.compositeName?contact.name.compositeName:@"untitled contact"];
            [myContactsData setPhoneNumber:contact.phones[0].number];
            [myContactsData setCreatedAt:[NSDate date]];
            [KatieDataManager save];
            
            NSLog(@"saved my contact address");
        }
        
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
            // update UI here
        });
    }
}

+ (KatieAddressData *)katieAddressDataForPhoneNumber:(NSString *)phoneNumber
{
    NSArray *fetchedObjects;
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetch = [NSFetchRequest new];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"KatieAddressData" inManagedObjectContext:moc];
    [fetch setEntity:entityDescription];
    
    NSError *error = nil;
    fetchedObjects = [moc executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count > 0)
    {
        for (KatieAddressData *addressData in fetchedObjects)
        {
            if ([addressData.phoneNumber isEqualToString:phoneNumber]) {
                return addressData;
            }
        }
    }
    
    return nil;
}

+ (KatieAddressData *)katieAddressDataForContactName:(NSString *)contactName
{
    NSArray *fetchedObjects;
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetch = [NSFetchRequest new];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"KatieAddressData" inManagedObjectContext:moc];
    [fetch setEntity:entityDescription];
    
    NSError *error = nil;
    fetchedObjects = [moc executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count > 0)
    {
        for (KatieAddressData *addressData in fetchedObjects)
        {
            if ([addressData.contactName isEqualToString:contactName]) {
                return addressData;
            }
        }
    }
    return nil;
}

+ (KatieAddressData *)searchUnsavedKatieAddressDataForContactName:(NSString *)contactName
{
    NSArray *fetchedObjects;
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetch = [NSFetchRequest new];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"KatieAddressData" inManagedObjectContext:moc];
    [fetch setEntity:entityDescription];
    
    NSError *error = nil;
    fetchedObjects = [moc executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count > 0)
    {
        for (KatieAddressData *addressData in fetchedObjects)
        {
            /*----------------------------------------------------------------------------*
             * Someone perhaps add more than 2 contacts with same name.
             * So ensure this addressData is checked in contactName and dummyCarrier.
             *----------------------------------------------------------------------------*/
            if ([addressData.contactName isEqualToString:contactName] && !addressData.dummyCarrier) {
                return addressData;
            }
        }
    }
    return nil;
}

+ (KatieAddressData *)katieAddressDataForMyName:(NSString *)myName
{
    NSArray *fetchedObjects;
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetch = [NSFetchRequest new];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"KatieAddressData" inManagedObjectContext:moc];
    [fetch setEntity:entityDescription];
    
    NSError *error = nil;
    fetchedObjects = [moc executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count > 0)
    {
        for (KatieAddressData *addressData in fetchedObjects)
        {
            if ([addressData.myName isEqualToString:myName]) {
                return addressData;
            }
        }
    }
    return nil;
}

+ (void)deleteAddressData:(KatieAddressData *)addressData
{
    if (addressData)
    {
        [[KatieDataManager sharedManager].managedObjectContext deleteObject:addressData];
        [KatieDataManager save];
    }
    
}

+ (void)deleteHistoryData:(KatieHistoryData *)historyData
{
    if (historyData)
    {
        [[KatieDataManager sharedManager].managedObjectContext deleteObject:historyData];
        [KatieDataManager save];
    }
    
}

+ (void)deleteAllAddressData
{
    NSManagedObjectContext *managedObjectContext = [KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KatieAddressData"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [managedObjectContext deleteObject:object];
        [KatieDataManager save];
    }
}

+ (NSArray *) allAddressData
{
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KatieAddressData"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching KatieAddressData objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    return results;
}

+ (NSArray *) allHistoryData
{
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KatieHistoryData"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching KatieHistoryData objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    return results;
}

@end
