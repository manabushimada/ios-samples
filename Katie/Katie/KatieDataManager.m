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

+ (KatieLookupData *)newLookupData
{
    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
    KatieLookupData *newLookupData = (KatieLookupData *) [NSEntityDescription insertNewObjectForEntityForName:@"KatieLookupData" inManagedObjectContext:moc];
    return newLookupData;
    
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
        KatieAddressData *myAddressData = [self newAddressData];
        [myAddressData setMyName:[[UIDevice currentDevice] name]];
        [myAddressData setCreatedAt:[NSDate date]];
        // TODO: register my carrier: post my number to twilio > fetch my carrier from them > set it into CoreData
        [self save];
        
        for (APContact *contact in contacts) {
            KatieAddressData *myContactsData = [self newAddressData];
            [myContactsData setName:contact.name.compositeName];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:contact.phones];
//            [addressData setMobileNumbers:data];
            [myContactsData setCarrier:[KatieNetworkManager randomCarrier]];
            [self save];
        }
    }
}

//+ (KatieAddressData *)searchAddressDataForPhoneNumber:(NSString *)phoneNumber
//{
//    NSArray *fetchedObjects;
//    NSManagedObjectContext *moc =[KatieDataManager sharedManager].managedObjectContext;
//    NSFetchRequest *fetch = [NSFetchRequest new];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"KatieAddressData" inManagedObjectContext:moc];
//    [fetch setEntity:entityDescription];
//    
//    NSError *error = nil;
//    fetchedObjects = [moc executeFetchRequest:fetch error:&error];
//    
//    if (fetchedObjects.count == 0)
//    {
//    }
//}

@end
