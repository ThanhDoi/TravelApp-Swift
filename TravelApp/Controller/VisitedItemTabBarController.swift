//
//  VisitedItemTabBarController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/19/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class VisitedItemTabBarController: UITabBarController {
    
    var trips: [Trip] = []
    var hotels: [Hotel] = []
    var attractions: [Attraction] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.tintColor = UIColor(red: 235.0/255.0, green: 75.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        tabBar.barTintColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.index(of: item)
        switch index {
        case 0:
            let destVC = viewControllers![index!] as! TripTableViewController
            destVC.trips = trips
            destVC.tableView.reloadData()
        case 1:
            let destVC = viewControllers![index!] as! HotelTableViewController
            destVC.hotels = hotels
            destVC.tableView.reloadData()
        case 2:
            let destVC = viewControllers![index!] as! AttractionTableViewController
            destVC.attractions = attractions
            destVC.tableView.reloadData()
        default:
            print("ABC")
        }
    }

}
