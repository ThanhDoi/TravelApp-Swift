//
//  FirstTimeRun.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/5/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreData

class FirstTimeRun {
    static let shared = FirstTimeRun()
    
    private init() {
        
    }
    
    func getHotels() {
        let url = "http://127.0.0.1:8000/api/hotels"
        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard response.result.isSuccess, let value = response.result.value else {
                print("Error while fetching colors: \(String(describing: response.result.error))")
                return
            }
            
            let json = JSON(value)
            for value in json {
                let data = value.1
                let hotel = Hotel(id: data["id"].int!, name: data["name"].string!, location: data["location"].string!, price: data["price"].string!, star: data["star"].string!, features: data["features"].string!, img_url: data["img_url"].string!, city_id: data["city_id"].int!)
                HotelData.shared.hotels.append(hotel)
            }
        }
    }
}
