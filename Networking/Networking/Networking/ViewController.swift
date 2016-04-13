//
//  ViewController.swift
//  Networking
//
//  Created by manabu shimada on 15/02/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    let managedObjectContext = ModelDataManager.sharedInstance.managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    let colorArray:NSArray = [UIColor.lightGrayColor(), UIColor.greenColor()]
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateNotification:", name:NetworkManager.sharedInstance.fetchedDataNotification, object: nil)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
        
        fetchedResultController = self.getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
        
        if fetchedResultController.fetchedObjects?.count == 0
        {
            //ModelDataManager.sharedInstance.saveModel( ["task": "CoreData YES!"])
            NetworkManager.sharedInstance.fetchData()
        }
        
        self.changeKishoSegment(segmentedControl)
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: self.modelFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func modelFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Model")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInsection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInsection!
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "subtitleCell")

        let model = fetchedResultController.objectAtIndexPath(indexPath) as! Model
        
        cell.textLabel?.text = model.task
        
        cell.detailTextLabel?.text = model.image
        
        cell.imageView!.image = UIImage(data:model.imageData!)?.resize(CGSizeMake(120, 120))
        cell.imageView?.contentMode = UIViewContentMode.ScaleToFill

        cell.backgroundColor = colorArray[model.done as! Int] as? UIColor
        if model.done == true {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject: NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    func updateNotification(notification: NSNotification?) {
        let data = notification?.object as! NSArray
        //print(String(data))
        self.updateData(data)
    }
    
    func updateData(data: NSArray) {
        for jsonDict in data {
            ModelDataManager.sharedInstance.downloadImage(jsonDict as! NSDictionary)
        }
        
    }
    
    @IBAction func changeKishoSegment(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            self.fetchedResultController.fetchRequest.predicate = NSPredicate(format: "done == 0")
            
            do {
                try fetchedResultController.performFetch()
            }
            catch let error as NSError {
                NSLog("%@", error.localizedDescription)
            }
            catch {
                fatalError()
            }
            tableView.reloadData()
        } else if (sender.selectedSegmentIndex == 1) {
            self.fetchedResultController.fetchRequest.predicate = NSPredicate(format: "done == 1")
            
            do {
                try fetchedResultController.performFetch()
            }
            catch let error as NSError {
                NSLog("%@", error.localizedDescription)
            }
            catch {
                fatalError()
            }
            tableView.reloadData()
        } else {
            self.fetchedResultController.fetchRequest.predicate = NSPredicate(format: "done == 0 || done ==1")
            
            do {
                try fetchedResultController.performFetch()
            }
            catch let error as NSError {
                NSLog("%@", error.localizedDescription)
            }
            catch {
                fatalError()
            }
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

