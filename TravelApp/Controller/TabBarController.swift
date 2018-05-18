//
//  TabBarController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/17/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import SwiftyJSON

class TabBarController: UITabBarController {
    
    var hotels: [Hotel] = []
    var cityID: Int = 0
    var isRecommend = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tabBar.items![0].title = "HOTEL"
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
            let destVC = viewControllers![index!] as! HotelTableViewController
            if isRecommend {
                destVC.isWaiting = true
                APIConnect.shared.requestAPI(urlRequest: Router.getHotelRecommend(cityID)) { (isSuccess, json) in
                    if isSuccess {
                        destVC.hotels = self.getHotelsResults(json: json)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: didGetRecommenderResults), object: nil)
                    } else {
                        destVC.isWrong = true
                    }
                }
            } else {
                destVC.hotels = Item.shared.hotels
            }
        case 1:
            let destVC = viewControllers![index!] as! AttractionTableViewController
            if isRecommend {
                destVC.isWaiting = true
                APIConnect.shared.requestAPI(urlRequest: Router.getAttractionRecommend(cityID)) { (isSuccess, json) in
                    if isSuccess {
                        destVC.attractions = self.getAttractionsResults(json: json)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: didGetAttractionRecommenderResults), object: nil)
                    } else {
                        destVC.isWrong = true
                    }
                }
            } else {
                destVC.attractions = Item.shared.attractions
            }
        default:
            print("ABC")
        }
    }
    
    func getHotelsResults(json: JSON) -> [Hotel] {
        var recommendResults = [Hotel]()
        if json["new_user"].exists() {
            let results = json["data"]
            for result in results {
                let data = result.1
                recommendResults.append(Item.shared.hotels[data.int! - 1])
            }
        } else {
            let CBData = json["CB"]
            let CFData = json["CF"]
            var CBResults = [Hotel]()
            var CFResults = [Hotel]()
            var CFSum: Double = 0.0
            var CBSum: Double = 0.0
            if !CBData.isEmpty {
                for eachData in CBData {
                    let data = eachData.1
                    CBSum = CBSum + Double(data["rating"].double!)
                }
                let CBAvg = CBSum / 20.0
                for eachData in CBData {
                    let dataCB = eachData.1
                    let id = dataCB["hotel_id"].int!
                    let rating = dataCB["rating"].double!
                    let hotel = Item.shared.hotels[id - 1]
                    hotel.diffWithAvgRating = rating - CBAvg
                    CBResults.append(hotel)
                }
            }
            if !CFData.isEmpty {
                for eachData in CFData {
                    for (_, value) in eachData.1 {
                        let rating = value.double!
                        CFSum = CFSum + rating
                    }
                }
                let CFAvg = CFSum / 20.0
                for eachData in CFData {
                    for (key, value) in eachData.1 {
                        let id = Int(key)
                        let rating = value.double!
                        let hotel = Item.shared.hotels[id! - 1]
                        hotel.diffWithAvgRating = rating - CFAvg
                        CFResults.append(hotel)
                    }
                }
            }
            for result in CBResults {
                if let index = CFResults.index(where: { (hotel) -> Bool in
                    return hotel.id == result.id
                }) {
                    let hotel = CFResults[index]
                    if result.diffWithAvgRating > hotel.diffWithAvgRating {
                        recommendResults.append(result)
                    } else {
                        recommendResults.append(hotel)
                    }
                }
            }
            recommendResults.sort(by: { (hotel1, hotel2) -> Bool in
                return hotel1.diffWithAvgRating > hotel2.diffWithAvgRating
            })
            CBResults.append(contentsOf: CFResults)
            CBResults.sort(by: { (hotel1, hotel2) -> Bool in
                return hotel1.diffWithAvgRating > hotel2.diffWithAvgRating
            })
            for result in CBResults {
                if !recommendResults.contains(where: { (hotel) -> Bool in
                    return result.id == hotel.id
                }) {
                    recommendResults.append(result)
                }
            }
            if recommendResults.count >= 20 {
                recommendResults = Array(recommendResults[0...19])
            }
        }
        return recommendResults
    }
    
    func getAttractionsResults(json: JSON) -> [Attraction] {
        var recommendResults = [Attraction]()
        if json["new_user"].exists() {
            var recommendResults = [Attraction]()
            let results = json["data"]
            for result in results {
                let data = result.1
                recommendResults.append(Item.shared.attractions[data.int! - 1])
            }
        } else {
            let CBData = json["CB"]
            let CFData = json["CF"]
            var CBResults = [Attraction]()
            var CFResults = [Attraction]()
            var CFSum: Double = 0.0
            var CBSum: Double = 0.0
            if !CBData.isEmpty {
                for eachData in CBData {
                    let data = eachData.1
                    CBSum = CBSum + Double(data["rating"].double!)
                }
                let CBAvg = CBSum / 20.0
                for eachData in CBData {
                    let dataCB = eachData.1
                    let id = dataCB["attraction_id"].int!
                    let rating = dataCB["rating"].double!
                    let attraction = Item.shared.attractions[id - 1]
                    attraction.diffWithAvgRating = rating - CBAvg
                    CBResults.append(attraction)
                }
            }
            if !CFData.isEmpty {
                for eachData in CFData {
                    for (_, value) in eachData.1 {
                        let rating = value.double!
                        CFSum = CFSum + rating
                    }
                }
                let CFAvg = CFSum / 20.0
                for eachData in CFData {
                    for (key, value) in eachData.1 {
                        let id = Int(key)
                        let rating = value.double!
                        let attraction = Item.shared.attractions[id! - 1]
                        attraction.diffWithAvgRating = rating - CFAvg
                        CFResults.append(attraction)
                    }
                }
            }
            for result in CBResults {
                if let index = CFResults.index(where: { (attraction) -> Bool in
                    return attraction.id == result.id
                }) {
                    let attraction = CFResults[index]
                    if result.diffWithAvgRating > attraction.diffWithAvgRating {
                        recommendResults.append(result)
                    } else {
                        recommendResults.append(attraction)
                    }
                }
            }
            recommendResults.sort(by: { (attraction1, attraction2) -> Bool in
                return attraction1.diffWithAvgRating > attraction2.diffWithAvgRating
            })
            CBResults.append(contentsOf: CFResults)
            CBResults.sort(by: { (attraction1, attraction2) -> Bool in
                return attraction1.diffWithAvgRating > attraction2.diffWithAvgRating
            })
            for result in CBResults {
                if !recommendResults.contains(where: { (attraction) -> Bool in
                    return result.id == attraction.id
                }) {
                    recommendResults.append(result)
                }
            }
            if recommendResults.count >= 20 {
                recommendResults = Array(recommendResults[0...19])
            }
        }
        return recommendResults
    }
    
}
