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
    
    var encode: ParameterEncoding!
    
    private init() {
        
    }
    
    func requestAPI(url: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: String = "",headers: HTTPHeaders, completion: @escaping ((_ data: JSON) -> Void)) {
        if encoding == "JSON" {
            self.encode = JSONEncoding.default
        } else {
            self.encode = URLEncoding.default
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: self.encode, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error while fetching colors: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                
                let json = JSON(value)
                completion(json)
        }
    }
}
