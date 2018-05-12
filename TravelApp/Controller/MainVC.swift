//
//  MainVC.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/3/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {
    
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
    
    @IBAction func showVisitedHotelButtonTapped(_ sender: UIBarButtonItem) {
        HotelList.shared.visitedHotels.removeAll()
        RunFirst.shared.getVisitedHotels {
            self.performSegue(withIdentifier: "showVisitedHotelsSegue", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAllHotelSegue" {
            if let destVC = segue.destination as? HotelTableViewController {
                destVC.hotels = HotelList.shared.hotels
            }
        }
        
        if segue.identifier == "showCityToRecommend" {
            if let destVC = segue.destination as? CitySelectionTableViewController {
                destVC.isForecast = false
            }
        }
        
        if segue.identifier == "showCityToViewForecast" {
            if let destVC = segue.destination as? CitySelectionTableViewController {
                destVC.isForecast = true
            }
        }
        
        if segue.identifier == "showVisitedHotelsSegue" {
            if let destVC = segue.destination as? HotelTableViewController {
                destVC.isVisited = true
                destVC.hotels = HotelList.shared.visitedHotels.sorted(by: { (hotel1, hotel2) -> Bool in
                    return (hotel1.visitedDate! < hotel2.visitedDate!)
                })
            }
        }
        
        if segue.identifier == "showBookmarkedHotels" {
            if let destVC = segue.destination as? HotelTableViewController {
                destVC.isBookmarked = true
            }
        }
    }
    
}
