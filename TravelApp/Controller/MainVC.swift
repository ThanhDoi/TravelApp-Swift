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
        Item.shared.visitedHotels.removeAll()
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
            if let destVC = segue.destination as? TabBarController {
                destVC.hotels = Item.shared.hotels
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
        
        if segue.identifier == "showSearchSegue" {
            if let destVC = segue.destination as? TabBarController {
                destVC.selectedIndex = 0
                destVC.tabBar(destVC.tabBar, didSelect: destVC.tabBar.items![0])
            }
        }
        
        if segue.identifier == "showBookmarkedItems" {
            if let destVC = segue.destination as? TabBarController {
                destVC.isBookmark = true
                destVC.selectedIndex = 0
                destVC.tabBar(destVC.tabBar, didSelect: destVC.tabBar.items![0])
            }
        }
    }
    
}
