//
//  AttractionTableViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/17/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class AttractionTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var attractions: [Attraction] = []
    var searchResults: [Attraction] = []
    var trip: Trip?
    var alert = UIAlertController()
    var isWaiting = false
    var isWrong = false
    var isRecommend = false
    var isBookmark = false
    
    var searchController: UISearchController!
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterHotel(for: searchText)
            tableView.reloadData()
        }
    }
    
    func filterHotel(for searchText: String) {
        searchResults = attractions.filter({ (attraction) -> Bool in
            let isMatch = attraction.name.localizedCaseInsensitiveContains(searchText) || attraction.location.localizedCaseInsensitiveContains(searchText)
            return isMatch
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isBookmark {
            var attractions = [Attraction]()
            for index in Item.shared.bookmarkedAttractions {
                attractions.append(Item.shared.attractions[index - 1])
            }
            self.attractions = attractions
            self.tableView.reloadData()
        }
        
        if let trip = trip {
            reloadVisitedData(trip: trip) {
                self.tableView.reloadData()
            }
        }
    }
    
    func reloadVisitedData(trip: Trip, completion: @escaping ()-> Void) {
        APIConnect.shared.requestAPI(urlRequest: Router.getItemsInTrip(trip.id)) { (isSuccess, json) in
            if isSuccess {
                var attractions = [Attraction]()
                let attractionIDs = json["attractions"]
                for attractionID in attractionIDs {
                    let data = attractionID.1
                    let attraction = Item.shared.attractions[data.int! - 1]
                    attractions.append(attraction)
                }
                self.attractions = attractions
                completion()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPleaseWait), name: NSNotification.Name(rawValue: didGetAttractionRecommenderResults), object: nil)
    }
    
    @objc private func dismissPleaseWait() {
        self.isWaiting = false
        self.alert.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: didGetAttractionRecommenderResults), object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isWrong {
            let alertController = UIAlertController(title: "Oops", message: "Something went wrong. Please try again!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if self.isWaiting {
                alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                
                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                loadingIndicator.startAnimating();
                
                alert.view.addSubview(loadingIndicator)
                present(alert, animated: true, completion: nil)
            }
        }
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
            return attractions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AttractionTableViewCell
        
        // Configure the cell...
        let attraction = searchController.isActive ? searchResults[indexPath.row] : attractions[indexPath.row]
        cell.attractionNameLabel.text = attraction.name
        cell.attractionLocationLabel.text = attraction.location
        if attraction.img == nil {
            if attraction.img_url.isEmpty == false {
                attraction.downloadImage(url: attraction.img_url) { (imageData) in
                    attraction.img = NSData(data: imageData) as Data
                    cell.attractionImageView.image = UIImage(data: attraction.img!)
                    tableView.reloadData()
                }
            } else {
                cell.attractionImageView.image = #imageLiteral(resourceName: "imagenotfound")
            }
        } else {
            cell.attractionImageView.image = UIImage(data: attraction.img!)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAttractionDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destVC = segue.destination as! AttractionDetailViewController
                destVC.attraction = searchController.isActive ? searchResults[indexPath.row] : attractions[indexPath.row]
                destVC.isRecommend = self.isRecommend
                destVC.trip = self.trip
            }
        }
    }
    
}
