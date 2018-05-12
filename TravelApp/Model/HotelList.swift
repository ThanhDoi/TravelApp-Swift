//
//  HotelData.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/6/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation

class HotelList {
    
    static let shared = HotelList()
    
    var hotels: [Hotel] = []
    var visitedHotels: [Hotel] = []
    var bookmarkedHotels: [Int] = []
    
    private init() {
        
    }
    
}
