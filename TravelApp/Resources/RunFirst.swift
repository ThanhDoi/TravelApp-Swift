//
//  FirstTimeRun.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/5/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation
import SwiftyJSON

class RunFirst {
    
    static let shared = RunFirst()
    var check = true
    
    private init() {
        
    }
    
    func checkConnection(completion: @escaping ((_ isSuccess: Bool) -> Void)) {
        APIConnect.shared.requestAPI(urlRequest: Router.checkConnection) { (isSuccess, json) in
            if (isSuccess) {
                completion(isSuccess)
            } else {
                completion(isSuccess)
            }
        }
    }
    
    func getHotels() {
        APIConnect.shared.requestAPI(urlRequest: Router.getHotels) { (isSuccess, json) in
            if isSuccess {
                for value in json {
                    let data = value.1
                    let hotel = Hotel(id: data["id"].int!, name: data["name"].string!, location: data["location"].string!, price: data["price"].string!, star: data["star"].string!, features: data["features"].string!, img_url: data["img_url"].string!, cityID: data["city_id"].int!)
                    Item.shared.hotels.append(hotel)
                }
            }
        }
    }
    
    func getVisitedHotels(completion: @escaping (() -> Void)) {
        APIConnect.shared.requestAPI(urlRequest: Router.getVisitedHotels) { (isSuccess, json) in
            if isSuccess {
                let results = json["data"]
                for result in results {
                    let data = result.1
                    let hotelID = data["hotel_id"].int
                    let dateString = data["created_at"].string
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.date(from: dateString!)
                    let hotel = Item.shared.hotels[hotelID! - 1]
                    hotel.visitedDate = date
                    Item.shared.visitedHotels.append(hotel)
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func getAttractions() {
        APIConnect.shared.requestAPI(urlRequest: Router.getAttractions) { (isSuccess, json) in
            if isSuccess {
                for value in json {
                    let data = value.1
                    let attraction = Attraction(id: data["id"].int!, name: data["name"].string!, location: data["location"].string!, features: data["features"].string!, img_url: data["img_url"].string!, cityID: data["city_id"].int!)
                    Item.shared.attractions.append(attraction)
                }
            }
        }
    }
    
}
