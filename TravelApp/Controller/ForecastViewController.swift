//
//  ForecastViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/4/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import ForecastIO

class ForecastViewController: UITableViewController {

    var daily: [DataPoint] = []
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.estimatedRowHeight = 130.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
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
        return daily.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ForecastTableViewCell

        // Configure the cell...
        let weatherData = daily[indexPath.row]
        cell.weatherIconImage.image = UIImage(named: (weatherData.icon?.rawValue)!)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, MMM dd"
        cell.dateLabel.text = dateFormatter.string(from: weatherData.time)
        cell.tempLabel.text = String(weatherData.temperatureHigh!) + " | " + String(weatherData.temperatureLow!)
        

        return cell
    }

}
