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
    case signIn(email: String, password: String)
    case verify(token: String)
    case resendEmailToken(email: String)
}

extension BeefficientAPI: EndPointType {
    public var baseURL: URL {
        return URL(string: "http://localhost:8000")!
    }
    
    public var path: String {
        switch self {
        case .signUp:
            return "/signUp"
        case .signIn:
            return "/login"
        case .verify(token: let token):
            return "/verify/" + token
        case .resendEmailToken(email: let email):
            return "/users/verify/" + email
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .signUp:
            return .put
        case .signIn, .verify, .resendEmailToken:
            return .post
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
                ], bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
            
        case .signIn(email: let email, password: let password):
            return .requestParametersAndHeaders(bodyParameters: [
                    "email": email,
                    "password": password
                ], bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        case .verify, .resendEmailToken:
            return .requestParametersAndHeaders(bodyParameters: [:], bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        }
    }
    
    public var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
}
