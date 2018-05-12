//
//  User.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/2/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import Foundation

class User {
    
    static var shared = User()
    
    private init() {
        
    }
    
    var name: String!
    var email: String!
    var apiToken: String!
    var userID: Int!
    
    func createUser() {
        self.name = UserDefaults.standard.value(forKey: "UserName") as! String
        self.email = UserDefaults.standard.value(forKey: "UserEmail") as! String
        self.apiToken = UserDefaults.standard.value(forKey: "UserApiToken") as! String
        self.userID = UserDefaults.standard.value(forKey: "UserId") as! Int
        Router.Constants.authenticationToken = "Bearer \(User.shared.apiToken!)"
    }
    
    func destroy() {
        UserDefaults.standard.removeObject(forKey: "hasSignedIn")
        UserDefaults.standard.removeObject(forKey: "UserName")
        UserDefaults.standard.removeObject(forKey: "UserEmail")
        UserDefaults.standard.removeObject(forKey: "UserApiToken")
        UserDefaults.standard.removeObject(forKey: "UserId")
        UserDefaults.standard.removeObject(forKey: "bookmarkedHotels")
        self.name = nil
        self.email = nil
        self.apiToken = nil
        self.userID = nil
    }
    
}
