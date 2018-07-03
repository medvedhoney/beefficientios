//
//  VerifyViewModel.swift
//  Beefficient
//
//  Created by Eugen on 23/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class VerifyViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    func verifyEmail(token: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.env.networkManager.verifyEmail(token: token, completion: { [weak self] (_, error) in
                DispatchQueue.main.async { [weak self] in
                    guard error == nil else {
                        self?.error = error
                        return
                    }
                    
                    self?.success = true
                }
            })
        }
    }
}
