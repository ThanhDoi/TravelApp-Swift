//
//  CitySelectionTableViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/8/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import ForecastIO

class CitySelectionTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchResults: [String] = []
    var isForecast = true
    var cityID = 0
    var searchController: UISearchController!
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterCity(for: searchText)
            tableView.reloadData()
        }
    }
    
    func filterCity(for searchText: String) {
        searchResults = cities.filter({ (city) -> Bool in
            let isMatch = city.localizedCaseInsensitiveContains(searchText)
            return isMatch
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            return searchResults.count
        } else {
            return cities.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = searchController.isActive ? searchResults[indexPath.row] : cities[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityID = indexPath.row
        if !isForecast {
            performSegue(withIdentifier: "showRecommend", sender: self)
        } else {
            performSegue(withIdentifier: "showWeather", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecommend" {
            if let destVC = segue.destination as? TabBarController {
                destVC.cityID = cityID
                destVC.isRecommend = true
                destVC.selectedIndex = 0
                destVC.tabBar(destVC.tabBar, didSelect: destVC.tabBar.items![0])
            }
        }
        
        if segue.identifier == "showWeather" {
            if let destVC = segue.destination as? ForecastViewController  {
                destVC.cityID = cityID
            }
        }
    }
    
}
