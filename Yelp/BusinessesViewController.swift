//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation


class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var searchController: UISearchController!;
    
    let locationManager: CLLocationManager = CLLocationManager()
    var locationString: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        queryYelp(searchTerm: "restaurants")
        /*
        Business.searchWithTerm(term: "thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.businessesFiltered = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }

            }

        )
        */
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: Error!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let coordinate = locations[0].coordinate
            let latitude = coordinate.latitude.description
            let longitude = coordinate.longitude.description
            locationString = latitude + ", " + longitude
            queryYelp(searchTerm: "restaurants")
            manager.stopUpdatingLocation()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let navBar = navigationController!.navigationBar
        navBar.barTintColor = UIColor(red:0.77, green:0.07, blue:0.00, alpha:1.0)
        navBar.tintColor = .white
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            queryYelp(searchTerm: searchText)
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        if(businesses != nil) {
            return businesses.count
        } else {
            print("busiinesses filtered is nil")
            return 0
        }
    }
    func queryYelp(searchTerm: String) {
        Business.searchWithTerm(locationString: locationString, term: searchTerm, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let error = error{
                print(error.localizedDescription)
            }
            self.businesses = businesses
            self.tableView.reloadData()
        }
            
        )
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    @IBAction func deselectSearch(_ sender: Any) {
        searchController.searchBar.endEditing(true)
    }
}
