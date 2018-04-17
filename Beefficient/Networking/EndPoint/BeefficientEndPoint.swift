//
//  BeefficientEndPoint.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 17/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

public enum BeefficientAPI {
    case signUp(name: String, email: String, password: String, phone: String)
}

extension BeefficientAPI: EndPointType {
    public var baseURL: URL {
        return URL(string: "http://localhost:8000")!
    }
    
    public var path: String {
        switch self {
        case .signUp:
            return "/signUp"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .signUp:
            return .put
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .signUp(let name, let email, let password, let phone):
            return .requestParametersAndHeaders(bodyParameters: [
                                                        "name": name,
                                                        "email": email,
                                                        "password": password,
                                                        "phone": phone
                                                    ],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        }
        
    }
    
    public var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
}
