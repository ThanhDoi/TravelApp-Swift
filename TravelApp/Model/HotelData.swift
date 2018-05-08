//
//  HotelData.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/6/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation

class HotelData {
    static let shared = HotelData()
    
    var hotels: [Hotel] = []
    
    private init() {
        
    }
}
