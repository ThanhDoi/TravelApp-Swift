//
//  Constant.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/8/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation
import UIKit

let didGetRecommenderResults = "didGetRecommenderResults"
let didGetAttractionRecommenderResults = "didGetAttractionRecommenderResults"
let didGetWeatherResults = "didGetWeatherResults"

let cities = ["Hà Nội", "Thành phố Hồ Chí Minh"]
let DarkSkyAPIKey = "cc4556a4d6ac753b46f7016852a9deda"

func createAlertController(title: String, mesage: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: mesage, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(okAction)
    return alertController
}
