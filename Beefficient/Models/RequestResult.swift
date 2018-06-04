//
//  RequestResult.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 01/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

struct RequestResult: Codable {
    let error: String?
    let result: Bool
    let user: User?
    let tasks: [Task]?
    let task: Task?
    let hives: [Hive]?
    let hive: Hive?
}
