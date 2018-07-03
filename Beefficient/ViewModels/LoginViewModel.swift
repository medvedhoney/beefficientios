//
//  LoginViewModel.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class LoginViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    func signIn(email: String, password: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.env.networkManager.signIn(email: email, password: password, completion: { (user, token, error) in
                DispatchQueue.main.async { [weak self] in
                    guard let user = user, error == nil else {
                        self?.error = error
                        return
                    }
                    
                    Environment.shared.saveCurrentUser(currentUser: user, token)
                    self?.success = true
                }
            })
        }
    }
}
