//
//  Trip.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/19/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation

class Trip {
    
    var id: Int!
    var name = ""
    var startDate: Date!
    var endDate: Date!
    var duration = ""
    
    init(id: Int, name: String, startDate: String, endDate: String) {
        self.id = id
        self.name = name
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.startDate = dateFormatter.date(from: startDate)!
        self.endDate = dateFormatter.date(from: endDate)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.duration = "From \(dateFormatter.string(from: self.startDate)) to \(dateFormatter.string(from: self.endDate))"
    }
}
