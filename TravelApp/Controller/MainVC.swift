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
        RunFirst.shared.getHotels()
        RunFirst.shared.getAttractions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showVisitedHotelButtonTapped(_ sender: UIBarButtonItem) {
        RunFirst.shared.getVisitedItems {
            self.performSegue(withIdentifier: "showVisitedItems", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
        
        if segue.identifier == "showSearchSegue" {
            if let destVC = segue.destination as? TabBarController {
                RunFirst.shared.getVisitedItems {
                }
                destVC.hotels = Item.shared.hotels
                destVC.attractions = Item.shared.attractions
                destVC.selectedIndex = 0
                destVC.tabBar(destVC.tabBar, didSelect: destVC.tabBar.items![0])
            }
        }
        
        if segue.identifier == "showBookmarkedItems" {
            if let destVC = segue.destination as? TabBarController {
                RunFirst.shared.getVisitedItems {
                }
                destVC.isBookmark = true
                destVC.selectedIndex = 0
                destVC.tabBar(destVC.tabBar, didSelect: destVC.tabBar.items![0])
            }
        }
        
        if segue.identifier == "showVisitedItems" {
            if let destVC = segue.destination as? VisitedItemTabBarController {
                destVC.hotels = Item.shared.visitedHotels
                destVC.attractions = Item.shared.visitedAttractions
                destVC.trips = Item.shared.visitedTrips
                destVC.selectedIndex = 0
                destVC.tabBar(destVC.tabBar, didSelect: destVC.tabBar.items![0])
            }
        }
    }
    
}
