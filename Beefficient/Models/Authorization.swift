//
//  Authorization.swift
//  Beefficient
//
//  Created by Eugen on 29/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

struct Authorization: Codable {
    var result: Bool?
    var user: User?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case user = "user"
        case token = "token"
    }
    
    init() { }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Bool.self, forKey: .result)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}
