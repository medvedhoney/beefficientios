//
//  HivesViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 02/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class HivesViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var hives: [Hive] = []
    
    func getHives() {
        env.networkManager.getUserHives { [weak self] (hives, error) in
            guard let hives = hives else {
                self?.error = error
                return
            }
            
            self?.hives = hives
            self?.success = true
        }
    }
}
