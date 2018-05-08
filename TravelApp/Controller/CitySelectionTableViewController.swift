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
    
    var cities = ["Hà Nội", "Thành phố Hồ Chí Minh"]
    var searchResults: [String] = []
    var isForecast = true
    var cityID = 0
    
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
    
    
    var searchController: UISearchController!
    
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
            if let destVC = segue.destination as? HotelTableViewController {
                let parameters = ["user_id": User.shared.user_id!, "city_id": cityID]
                let headers = ["Accept": "application/json",
                               "Content-Type": "application/json"]
                destVC.isWaiting = true
                APIConnect.shared.requestAPI(url: "http://127.0.0.1:8000/api/predict", method: .get, parameters: parameters, encoding: "", headers: headers) { (json) in
                    let CBData = json["CB"]
                    let CFData = json["CF"]
                    var CBResults = [Hotel]()
                    var CFResults = [Hotel]()
                    var CFSum: Double = 0.0
                    var CBSum: Double = 0.0
                    for eachData in CBData {
                        let x = eachData.1
                        CBSum = CBSum + Double(x["rating"].double!)
                    }
                    let CBAvg = CBSum / 20.0
                    for i in 0...9 {
                        let dataCB = CBData[i]
                        let id = dataCB["hotel_id"].int!
                        let rating = dataCB["rating"].double!
                        let hotel = HotelData.shared.hotels[id - 1]
                        hotel.diffWithAvgRating = rating - CBAvg
                        CBResults.append(hotel)
                    }
                    for eachData in CFData {
                        for (key, value) in eachData.1 {
                            let rating = value.double!
                            CFSum = CFSum + rating
                        }
                    }
                    let CFAvg = CFSum / 20.0
                    for i in 0...9 {
                        let eachData = CFData[i]
                        for (key, value) in eachData {
                            let id = Int(key)
                            let rating = value.double!
                            let hotel = HotelData.shared.hotels[id! - 1]
                            hotel.diffWithAvgRating = rating - CFAvg
                            CFResults.append(hotel)
                        }
                    }
                    CBResults.append(contentsOf: CFResults)
                    destVC.hotels = CBResults
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: didGetRecommenderResults), object: nil)
                }
            }
        }
        
        if segue.identifier == "showWeather" {
            if let destVC = segue.destination as? ForecastViewController {
                let client = DarkSkyClient(apiKey: "cc4556a4d6ac753b46f7016852a9deda")
                client.units = .si
                var latitude: Double = 0
                var longitude: Double = 0
                if self.cityID == 0 {
                    latitude = 21.028511
                    longitude = 105.804817
                }
                client.getForecast(latitude: latitude, longitude: longitude, extendHourly: false, excludeFields: [.currently, .minutely, .hourly, .alerts, .flags]) { (result) in
                    switch result {
                    case .success(let forecast, let requestMetadata):
                        destVC.daily = forecast.daily?.data as! [DataPoint]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: didGetWeatherResults), object: nil)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
}
