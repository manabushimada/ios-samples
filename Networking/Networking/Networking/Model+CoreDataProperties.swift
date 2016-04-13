//
//  Model+CoreDataProperties.swift
//  Networking
//
//  Created by manabu shimada on 15/02/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Model {

    @NSManaged var task: String?
    @NSManaged var image: String?
    @NSManaged var done: NSNumber?
    @NSManaged var createdAt: NSDate?
    @NSManaged var imageData: NSData?

}
