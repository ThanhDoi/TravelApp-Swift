//
//  Hotel.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/6/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class Hotel {
    
    var id: Int!
    var name = ""
    var location = ""
    var price = ""
    var star = ""
    var features = ""
    var img_url = ""
    var img: Data?
    var city_id = 0
    var diffWithAvgRating: Double!
    var visitedDate: Date?
    
    init(id: Int,name: String, location: String, price: String, star: String, features: String, img_url: String, city_id: Int) {
        self.id = id
        self.name = name
        self.location = location
        self.price = price
        self.star = star
        self.city_id = city_id
        let regex = "\\'(.*?)\\'"
        let results = matchesForRegexInText(regex: regex, text: features)
        for result in results {
            self.features = self.features + "- \(String(result.dropLast().dropFirst()))\n"
        }
        self.img_url = img_url
    }
    
    func downloadImage(url: String, completion: @escaping (_ image: Data) -> Void) {
        Alamofire.request(url, method: .get).responseImage { (response) in
            guard let image = response.result.value else {
                return
            }
            if let imageData = UIImagePNGRepresentation(image) {
                completion(imageData)
            }
        }
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}
