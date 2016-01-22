//
//  CountryInfo+CoreDataProperties.swift
//  Countries
//
//  Created by Yakov Shkolnikov on 1/20/16.
//  Copyright © 2016 junor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CountryInfo {

    @NSManaged var name: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var flagImage: NSObject?

}
