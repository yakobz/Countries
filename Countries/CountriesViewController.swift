//
//  CountriesViewController.swift
//  Countries
//
//  Created by Yakov Shkolnikov on 1/19/16.
//  Copyright © 2016 junor. All rights reserved.
//

import UIKit
import MapKit

class CountriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var countries = [CountryInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.mapView.delegate = self
        
        self.tableView!.registerNib(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryTableViewCell")

        self.countriesInfoAvailable(nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "countriesInfoAvailable:", name: "CountriesInfoAvailable", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Notification
    
    func countriesInfoAvailable(notification: NSNotification?) {
        self.countries = DataManager.sharedInstance.getAllCountries()!
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: UISegmentedControl change index
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.view.insertSubview(mapView, atIndex: 0)
        } else {
            self.view.insertSubview(mapView, aboveSubview: self.searchBar)
            self.view.insertSubview(mapView, aboveSubview: self.tableView)
        }
        
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.segmentedControl.selectedSegmentIndex = 1
        self.segmentedControlIndexChanged(self.segmentedControl)
        
        let latitude = (self.countries[indexPath.row].latitude?.doubleValue)!
        let longitude = (self.countries[indexPath.row].longitude?.doubleValue)!
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = CountryAnnotation(initWithCoordinate: coordinate, title: self.countries[indexPath.row].name!, andImageName: self.countries[indexPath.row].name)

        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        self.mapView.setCenterCoordinate(annotation.coordinate, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66.0
    }


    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CountryTableViewCell", forIndexPath: indexPath) as! CountryTableViewCell
        
        cell.selectionStyle = .None
        cell.label.text = self.countries[indexPath.row].name!
        cell.flagImageView.image = UIImage(named: self.countries[indexPath.row].name!)
        
        if cell.flagImageView.image == nil {
            cell.flagImageView.image = UIImage(named: "Default")
        }
        
        return cell
    }
    

    
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.countries = DataManager.sharedInstance.getAllCountries()!
            
            self.searchBar.resignFirstResponder()
        } else {
            var resultArray = [CountryInfo]()
            
            for country in self.countries {
                let name = country.name
                
                if name?.lowercaseString.rangeOfString((searchBar.text?.lowercaseString)!) != nil {
                    resultArray.append(country)
                }
            }
            
            self.countries = resultArray
        }

        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }


    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let countryAnnotation = annotation as! CountryAnnotation
        var annView = mapView.dequeueReusableAnnotationViewWithIdentifier("MyAnnotation")
        
        if annView == nil {
            annView = MKAnnotationView(annotation: countryAnnotation, reuseIdentifier: "MyAnnotation")
            annView?.canShowCallout = true
        } else {
            annView?.annotation = countryAnnotation
        }
        
        annView?.image = UIImage(named: countryAnnotation.imageName!)
            
        if annView?.image == nil {
            annView?.image = UIImage(named: "Default")
        }
        
        return annView
    }
}

