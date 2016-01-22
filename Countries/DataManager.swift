//
//  DataManager.swift
//  Countries
//
//  Created by Yakov Shkolnikov on 1/20/16.
//  Copyright © 2016 junor. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    let appDelegate: AppDelegate
    
    let url = NSURL(string: "https://restcountries.eu/rest/v1/all")!
    
    override init() {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        super.init()
    }
    
    func getCountriesFlagsNamesAndCoordinates() {
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(self.url) { (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
            if data != nil {
                do {
                    let countriesArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    
                    self.parseJSONFromArray(countriesArray as! NSArray)
                    
                } catch {
                    
                }
            }
        }
        
        dataTask.resume()
    }
    
    func parseJSONFromArray(let array: NSArray) {
        for dictionaryInfo in array {
            if let dictionary = dictionaryInfo as? NSDictionary {
                
                let latlng = dictionary["latlng"] as! NSArray
                
                if latlng.count == 0 {
                    continue
                }

                let countryInfo = NSEntityDescription.insertNewObjectForEntityForName("CountryInfo", inManagedObjectContext: self.appDelegate.managedObjectContext) as! CountryInfo
                
                countryInfo.name = dictionary["name"] as? String
                countryInfo.latitude = (latlng[0] as! NSNumber).doubleValue
                countryInfo.longitude = (latlng[1] as! NSNumber).doubleValue
            }
        }
        
        self.appDelegate.saveContext()
        NSNotificationCenter.defaultCenter().postNotificationName("CountriesInfoAvailable", object: nil);
    }
    
    func countriesAvailable() -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "CountryInfo")
        
        do {
            let fetchedItems = try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [CountryInfo]
            
            if fetchedItems?.count != 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func getAllCountries() -> [CountryInfo]? {
        let fetchRequest = NSFetchRequest(entityName: "CountryInfo")
        
        do {
            var fetchedItems = try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [CountryInfo]
            
            fetchedItems = fetchedItems?.sort({ (let country1: CountryInfo, let country2: CountryInfo) -> Bool in
                return country1.name < country2.name
            })
            
            return fetchedItems
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
            return nil
        }
    }
}









