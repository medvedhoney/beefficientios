//
//  Task.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 30/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

struct Task: Codable {
    let id: String
    let description: String
    let owner: String
    let hive: String
    let percent: Int
    let status: String
    let privateTask: Bool
    let deadline: String
    let requiredAssignees: Int
    let chatDate: [ChatDate]
    let chat: [Chat]
    let assignee: [String]
    let creationDate: String
    
    enum CodingKeys: String, CodingKey {
        case privateTask = "private"
        case id, description, owner, hive, percent, status, deadline, requiredAssignees, chatDate, chat, assignee, creationDate
    }
}
