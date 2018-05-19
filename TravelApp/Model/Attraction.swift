//
//  Attraction.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/17/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation

class Attraction {
    
    var id: Int!
    var name = ""
    var location = ""
    var features = ""
    var img_url = ""
    var img: Data?
    var cityID = 0
    var diffWithAvgRating: Double!
    var visitedDate: Date?
    
    init(id: Int, name: String, location: String, features: String, img_url: String, cityID: Int) {
        self.id = id
        self.name = name
        self.location = location
        self.features = features
        self.img_url = img_url
        self.cityID = cityID
    }
}
