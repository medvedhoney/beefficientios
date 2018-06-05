//
//  SignUpViewModel.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class SignUpViewModel: NSObject {
    let validation = Validation.shared
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var validData = false
    dynamic var error: String?
    
    func validateData(name: String?, email: String?, phone: String?, password: String?, repeatedPassword: String?) {
        guard
            name != nil,
            email != nil,
            phone != nil,
            let password = password,
            let repeatedPassword = repeatedPassword
        else {
            validData = false
            return
        }
        
        validData = validation.validatePassword(password).isValid && validation.validateRepeatedPassword(password, repeatedPassword).isValid
    }
    
    func signUp(name: String, email: String, phone: String, password: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.env.networkManager.signUp(name: name, email: email, phone: phone, password: password) { (user, error) in
                DispatchQueue.main.async { [weak self] in
                    guard let user = user, error == nil else {
                        self?.error = error
                        return
                    }
                    
                    Environment.shared.user = user
                    self?.success = true
                }
            }
        }
    }
}
