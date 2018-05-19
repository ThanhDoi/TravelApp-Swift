//
//  TripTableViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/19/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class TripTableViewController: UITableViewController {
    
    var trips: [Trip] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TripTableViewCell

        // Configure the cell...
        cell.nameLabel.text = trips[indexPath.row].name
        cell.durationLabel.text = trips[indexPath.row].duration

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = trips[indexPath.row]
            APIConnect.shared.requestAPI(urlRequest: Router.deleteTrip(trip.id)) { (isSuccess, json) in
                self.trips.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTripDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destVC = segue.destination as! TabBarController
                destVC.trip = trips[indexPath.row]
                let tripID = trips[(indexPath.row)].id
                APIConnect.shared.requestAPI(urlRequest: Router.getItemsInTrip(tripID!)) { (isSuccess, json) in
                    if isSuccess {
                        var attractions = [Attraction]()
                        var hotels = [Hotel]()
                        let attractionIDs = json["attractions"]
                        let hotelIDs = json["hotels"]
                        for attractionID in attractionIDs {
                            let data = attractionID.1
                            let attraction = Item.shared.attractions[data.int! - 1]
                            attractions.append(attraction)
                        }
                        for hotelID in hotelIDs {
                            let data = hotelID.1
                            let hotel = Item.shared.hotels[data.int! - 1]
                            hotels.append(hotel)
                        }
                        destVC.hotels = hotels
                        destVC.attractions = attractions
                        destVC.selectedIndex = 0
                        destVC.tabBar(destVC.tabBar, didSelect: destVC.tabBar.items![0])
                    }
                }
            }
        }
    }

}
