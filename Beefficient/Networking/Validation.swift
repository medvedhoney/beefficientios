//
//  Validation.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class Validation: ValidationService {
    static let shared = Validation()
    
    let passwordLength = 8
    
    func validatePassword(_ password: String) -> ValidationResult {
        if password.count == 0 {
            return .empty
        }
        
        if password.count < passwordLength {
            return .failed(message: "Password must be at least \(passwordLength) characters!")
        }
        
        return .ok(message: "Password acceptable!")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if password.count == 0 {
            return .empty
        }
        
        if password != repeatedPassword {
            return .failed(message: "Password different!")
        }
        
        return .ok(message: "Password ok!")
    }
    

}
