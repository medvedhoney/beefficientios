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
    
    var user: User?
    
    private init() {  }
}
