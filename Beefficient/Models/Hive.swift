//
//  Hive.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 02/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

struct Hive: Codable {
    let id: String
    let owner: String
    let name: String
    let status: String
    let users: [String]
}
