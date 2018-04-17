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
    
    dynamic var validData = false
    
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
}
