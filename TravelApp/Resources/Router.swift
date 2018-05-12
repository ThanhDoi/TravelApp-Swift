//
//  Router.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/10/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Alamofire

public enum Router: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "http://127.0.0.1:8000/api"
        static var authenticationToken = "Bearer "
    }
    
    case login(String, String)
    case logout
    case signup(String, String, String, String)
    case getHotels
    case changeInfo(String, String)
    case getRecommend(Int, String)
    case getHotelAvgRating(Int)
    case getHotelRatedScore(Int)
    case rateHotel(Int, Int)
    case rateHotelRecommend(Int, Int)
    case getVisitedHotels
    case checkConnection
    
    var method: HTTPMethod {
        switch self {
        case .login, .signup, .rateHotel, .rateHotelRecommend:
            return .post
        case .changeInfo:
            return .put
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .getHotels:
            return "/hotels"
        case .signup:
            return "/register"
        case .changeInfo:
            return "/users/"
        case .getRecommend:
            return "/getRecommend"
        case .getHotelAvgRating(let hotelID):
            return "/hotels/\(hotelID)/avgRating"
        case .getHotelRatedScore(let hotelID):
            return "/hotels/\(hotelID)/ratedScore"
        case .rateHotel(let hotelID, _):
            return "/hotels/\(hotelID)/rate"
        case .rateHotelRecommend(let hotelID, _):
            return "/hotels/\(hotelID)/rateRecommend"
        case .getVisitedHotels:
            return "/users/visitedHotels"
        case .checkConnection:
            return "/checkConnect"
        default:
            return "/"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .signup(let name, let email, let password, let passwordConfirmation):
            return ["name": name, "email": email, "password": password, "password_confirmation": passwordConfirmation]
        case .changeInfo(let name, let password):
            return ["name": name, "password": password]
        case .getRecommend(let cityID, _):
            return ["city_id": cityID]
        case .rateHotel(_, let rate):
            return ["rate": rate]
        case .rateHotelRecommend(_, let rate):
            return ["rate": rate]
        default:
            return [:]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
}
