//
//  HotelData.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/6/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation

class Item {
    
    static let shared = Item()
    
    var hotels: [Hotel] = []
    var attractions: [Attraction] = []
    var visitedHotels: [Hotel] = []
    var visitedAttractions: [Attraction] = []
    var visitedTrips: [Trip] = []
    var bookmarkedHotels: [Int] = []
    var bookmarkedAttractions: [Int] = []
    
    private init() {
        
    }
    
}
