//
//  SettingsViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 09/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class SettingsViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var user: User = Environment.shared.user!
    
    var dataSource: [(key: String, value: String)] {
        get {
            return [
                ("name", user.name),
                ("email", user.email),
                ("phone", user.phone),
                ("password", "********")
            ]
        }
    }
    
    func updateUser(key: String, value: String) {
        env.networkManager.updateUser(parameters: [key : value]) { [weak self] (user, error) in
            guard let user = user else {
                self?.error = error
                return
            }
            
            self?.env.user = user
            self?.user = user
            self?.success = true
        }
    }
    
    func logout() {
        env.networkManager.logout { [weak self] (success, error) in
            if let success = success, success {
                self?.env.logoutUser()
            }
        }
    }

}
