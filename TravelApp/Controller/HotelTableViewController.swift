//
//  HotelTableViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/7/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class HotelTableViewController: UITableViewController, UISearchResultsUpdating {

    var hotels: [Hotel] = []
    var searchResults: [Hotel] = []
    var isWaiting = false
    var isWrong = false
    var isVisited = false
    var isNewUser = false
    var isRecommend = false
    var isBookmarked = false
    
    var searchController: UISearchController!
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterHotel(for: searchText)
            tableView.reloadData()
        }
    }
    
    func filterHotel(for searchText: String) {
        searchResults = hotels.filter({ (hotel) -> Bool in
            let isMatch = hotel.name.localizedCaseInsensitiveContains(searchText) || hotel.location.localizedCaseInsensitiveContains(searchText)
            
            return isMatch
        })
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPleaseWait), name: NSNotification.Name(rawValue: didGetRecommenderResults), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isBookmarked {
            var hotels = [Hotel]()
            for index in HotelList.shared.bookmarkedHotels {
                hotels.append(HotelList.shared.hotels[index - 1])
            }
            self.hotels = hotels
            self.tableView.reloadData()
        }
    }
    
    @objc private func dismissPleaseWait() {
        self.isWaiting = false
        if !self.isNewUser {
            dismiss(animated: true, completion: nil)
            self.hotels.sort { (hotel1, hotel2) -> Bool in
                return hotel1.diffWithAvgRating > hotel2.diffWithAvgRating
            }
        }
        self.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: didGetRecommenderResults), object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isWrong {
            let alertController = createAlertController(title: "Oops", mesage: "Something went wrong. Please try again!")
            self.present(alertController, animated: true, completion: nil)
        } else {
            if self.isWaiting {
                let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                
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
            return hotels.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotelTableViewCell
        
        // Configure the cell...
        let hotel = searchController.isActive ? searchResults[indexPath.row] : hotels[indexPath.row]
        cell.hotelNameLabel.text = hotel.name
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, MMM dd YYYY"
        cell.hotelLocationLabel.text = isVisited ? dateFormatter.string(from: hotel.visitedDate!) : hotel.location
        if hotel.img == nil {
            if hotel.img_url.isEmpty == false {
                hotel.downloadImage(url: hotel.img_url) { (imageData) in
                    hotel.img = NSData(data: imageData) as Data
                    cell.hotelImageView.image = UIImage(data: hotel.img!)
                    tableView.reloadData()
                }
            } else {
                cell.hotelImageView.image = #imageLiteral(resourceName: "imagenotfound")
            }
        } else {
            cell.hotelImageView.image = UIImage(data: hotel.img!)
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showHotelDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destVC = segue.destination as! HotelDetailViewController
                destVC.hotel = searchController.isActive ? searchResults[indexPath.row] : hotels[indexPath.row]
                destVC.isRecommend = self.isRecommend
            }
        }
    }
}
