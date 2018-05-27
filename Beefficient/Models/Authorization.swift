//
//  Authorization.swift
//  Beefficient
//
//  Created by Eugen on 29/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

struct Authorization: Codable {
    var result: Bool
    var user: User?
    var token: String?
    var error: String?
}
