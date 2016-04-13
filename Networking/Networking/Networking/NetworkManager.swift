//
//  NetworkManager.swift
//  Networking
//
//  Created by manabu shimada on 16/02/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    let fetchedDataNotification = "fetchedDataNotification"
    
    let jsonUrl = "https://bitbucket.org/fatunicorn/iostest/raw/78f902ddb31ac96bb23b901054442dee52664271/data/tasklist.json"
    
    static let sharedInstance = NetworkManager()

    func fetchData(){
    let session = NSURLSession.sharedSession()
    let shotsUrl = NSURL(string: jsonUrl)
    
    let task = session.dataTaskWithURL(shotsUrl!) {
        (data, response, error) -> Void in
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSArray
            
            //print(String(jsonData))
            
            NSNotificationCenter.defaultCenter().postNotificationName(self.fetchedDataNotification, object:jsonData)
            
        } catch _ {
            // Error
        }
        }
        task.resume()
    }
}
