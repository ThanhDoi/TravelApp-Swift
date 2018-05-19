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
    case getAttractions
    case getVisitedItems
    
    case changeInfo(String, String)
    
    case getHotelRecommend(Int)
    case getHotelAvgRating(Int)
    case rateHotel(Int, Int)
    case rateHotelRecommend(Int, Int)
    
    case checkConnection
    
    case getAttractionRecommend(Int)
    case getAttractionAvgRating(Int)
    case rateAttraction(Int, Int)
    case rateAttractionRecommend(Int, Int)
    
    case createTripByHotel(String, String, String, Int)
    case createTripByAttraction(String, String, String, Int)
    case getItemsInTrip(Int)
    case addHotelToTrip(Int, Int)
    case addAttractionToTrip(Int, Int)
    case removeHotelFromTrip(Int, Int)
    case removeAttractionFromTrip(Int, Int)
    case deleteTrip(Int)
    
    var method: HTTPMethod {
        switch self {
        case .login, .signup, .rateHotel, .rateHotelRecommend, .rateAttraction, .rateAttractionRecommend, .createTripByHotel, .createTripByAttraction, .addHotelToTrip, .addAttractionToTrip, .removeHotelFromTrip, .removeAttractionFromTrip:
            return .post
        case .changeInfo:
            return .put
        case .deleteTrip:
            return .delete
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
        case .getVisitedItems:
            return "/users/visitedItems"
            
        case .changeInfo:
            return "/users/"
            
        case .getHotelRecommend:
            return "/getHotelRecommend"
        case .getAttractionRecommend:
            return "/getAttractionRecommend"
            
        case .getHotelAvgRating(let hotelID):
            return "/hotels/\(hotelID)/avgRating"
        case .rateHotel(let hotelID, _):
            return "/hotels/\(hotelID)/rate"
        case .rateHotelRecommend(let hotelID, _):
            return "/hotels/\(hotelID)/rateRecommend"
       
        case .checkConnection:
            return "/checkConnect"
            
        case .getAttractions:
            return "/attractions"
        case .getAttractionAvgRating(let attractionID):
            return "/attractions/\(attractionID)/avgRating"
        case .rateAttraction(let attractionID, _):
            return "/attractions/\(attractionID)/rate"
        case .rateAttractionRecommend(let attractionID, _):
            return "/attractions/\(attractionID)/rateRecommend"
            
        case .createTripByHotel:
            return "/trips/createTripByHotel"
        case .createTripByAttraction:
            return "/trips/createTripByAttraction"
        case .getItemsInTrip(let tripID):
            return "/trips/\(tripID)/getItemsInTrip"
        case .addHotelToTrip(let tripID, _):
            return "/trips/\(tripID)/addHotel"
        case .addAttractionToTrip(let tripID, _):
            return "/trips/\(tripID)/addAttraction"
        case .removeHotelFromTrip(let tripID, _):
            return "/trips/\(tripID)/removeHotel"
        case .removeAttractionFromTrip(let tripID, _):
            return "/trips/\(tripID)/removeAttraction"
        case .deleteTrip(let tripID):
            return "/trips/\(tripID)"
            
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
        case .getHotelRecommend(let cityID):
            return ["city_id": cityID]
        case .getAttractionRecommend(let cityID):
            return ["city_id": cityID]
        case .rateHotel(_, let rate):
            return ["rate": rate]
        case .rateHotelRecommend(_, let rate):
            return ["rate": rate]
        case .rateAttraction(_, let rate):
            return ["rate": rate]
        case .rateAttractionRecommend(_, let rate):
            return ["rate": rate]
        case .createTripByHotel(let tripName, let tripStartDate, let tripEndDate, let hotelID):
            return ["trip_name": tripName, "start_date": tripStartDate, "end_date": tripEndDate, "hotel_id": hotelID]
        case .createTripByAttraction(let tripName, let tripStartDate, let tripEndDate, let attractionID):
            return ["trip_name": tripName, "start_date": tripStartDate, "end_date": tripEndDate, "attraction_id": attractionID]
        case .addHotelToTrip(_, let hotelID):
            return ["hotel_id": hotelID]
        case .addAttractionToTrip(_, let hotelID):
            return ["hotel_id": hotelID]
        case .removeHotelFromTrip(_, let hotelID):
            return ["hotel_id": hotelID]
        case .removeAttractionFromTrip(_, let hotelID):
            return ["hotel_id": hotelID]
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
