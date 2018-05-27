//
//  Environment.swift
//  Beefficient
//
//  Created by Eugen on 18/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

class Environment {
    static let shared = Environment()
    
    let networkManager = NetworkManager()
    let defauls = UserDefaults.standard
    
    let userTokenKey = "userToken"
    let userIdKey = "userId"
    
    var user: User?
    
    private init() {  }
    
    func saveCurrentUser(currentUser: User, _ token: String? = nil) {
        if let token = token {
            defauls.set(token, forKey: userTokenKey)
        }
        defauls.set(currentUser.id, forKey: userIdKey)
        user = currentUser
    }
    
    func getUserToken() -> String? {
        return defauls.string(forKey: userTokenKey)
    }
    
    func getUserId() -> String? {
        return defauls.string(forKey: userIdKey)
    }
}
