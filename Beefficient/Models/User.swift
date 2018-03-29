//
//  User.swift
//  Beefficient
//
//  Created by Eugen on 29/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

struct User: Codable {
    let id: String?
    let name: String?
    let email: String?
    let phone: String?
    let status: String?
    let account: [String : String]?
    let android: [String]?
    let ios: [String]?
    let creationDate: String?
    let verified: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case status = "status"
        case account = "account"
        case android = "android"
        case ios = "ios"
        case creationDate = "creationDate"
        case verified = "verified"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .id)
        phone = try values.decodeIfPresent(String.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .id)
        account = try values.decodeIfPresent([String : String].self, forKey: .id)
        android = try values.decodeIfPresent([String].self, forKey: .id)
        ios = try values.decodeIfPresent([String].self, forKey: .id)
        creationDate = try values.decodeIfPresent(String.self, forKey: .id)
        verified = try values.decodeIfPresent(Bool.self, forKey: .id)
    }
}
