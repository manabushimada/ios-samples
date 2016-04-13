//
//  ModelDataManager.swift
//  Networking
//
//  Created by manabu shimada on 16/02/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ModelDataManager {
    
    let entityName:String = "Model"
    let createdAtName:String = "createdAt"
    let imageName:String = "image"
    let taskName:String = "task"
    let doneName:String = "done"
    let imageDataName:String = "imageData"

    static let sharedInstance = ModelDataManager()
    
    func newModel(newDictionary: NSDictionary){
        
        /* Get ManagedObjectContext*/
        let managedContext: NSManagedObjectContext = self.managedObjectContext
        
        /* Create new ManagedObject */
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedContext)
        let modelObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        /* Set the name attribute using key-value coding */
        let task = newDictionary[taskName]
        let image = newDictionary[imageName]
        let done = newDictionary[doneName]
        let imageData = newDictionary[imageDataName]
        
        modelObject.setValue(image, forKey: imageName)
        modelObject.setValue(task, forKey: taskName)
        modelObject.setValue(done, forKey: doneName)
        modelObject.setValue(NSDate(), forKey: createdAtName)
        modelObject.setValue(imageData, forKey: imageDataName)
        
        /* Error handling */
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("object saved")
        }
    }
    
    func fetchModelData() {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Model", inManagedObjectContext: self.managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            print(result)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    func updateImage(managedObject: NSManagedObject, data: NSData) {
        
        /* Get ManagedObjectContext from AppDelegate */
        //let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = self.managedObjectContext
        
        /* Change value of managedObject */
        managedObject.setValue(data, forKey: imageDataName)
        
        /* Save value to managedObjectContext */
        do {
            try managedContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        print("Object updated")
    }
    
    
    func deleteName(managedObject: NSManagedObject) {
        
        /* Get ManagedObjectContext from AppDelegate */
        let managedContext: NSManagedObjectContext = self.managedObjectContext
        
        /* Delete managedObject from managed context */
        managedContext.deleteObject(managedObject)
        
        /* Save value to managed context */
        do {
            try managedContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        print("Object deleted")
        
    }
    

    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(json: NSDictionary) {
        let url = NSURL(string:(json["image"] as? String)!)
        
        print("Download Started")
        print("lastPathComponent: " + (url!.lastPathComponent ?? ""))
        getDataFromUrl(url!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                let newDict = NSMutableDictionary(dictionary: json)
                data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                newDict[self.imageDataName] = data
                
                self.newModel(newDict)
            }
        }
    }
    
    

    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.manabushimada.Networking" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Networking", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
