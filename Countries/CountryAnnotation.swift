//
//  CountryAnnotation.swift
//  Countries
//
//  Created by Yakov Shkolnikov on 1/22/16.
//  Copyright © 2016 junor. All rights reserved.
//

import UIKit
import MapKit

class CountryAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var imageName: String?
    
    init(initWithCoordinate coordinate:CLLocationCoordinate2D, title:String, andImageName imageName:String?) {
        self.coordinate = coordinate
        self.imageName = imageName
        self.title = title
        
        super.init()
    }
}
