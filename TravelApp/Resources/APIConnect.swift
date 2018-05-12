//
//  APIConnect.swift
//  TravelApp
//
//  Created by Thanh Doi on 4/27/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIConnect {
    
    static let shared = APIConnect()
    
    private init() {
        
    }
    
    func requestAPI(urlRequest: URLRequestConvertible, completion: @escaping ((_ isSuccess: Bool, _ data: JSON) -> Void)) {
        Alamofire.request(urlRequest).responseJSON { (response) in
            guard response.result.isSuccess, let value = response.result.value else {
                print("Error while fetching colors: \(String(describing: response.result.error))")
                completion(false, nil)
                return
            }
            
            let json = JSON(value)
            completion(true, json)
        }
    }
    
}
