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
    case getUser(userId: String)
    case getTasks
}

extension BeefficientAPI: EndPointType {
    public var baseURL: URL {
        return URL(string: "http://localhost:8000")!
    }
    
    public var path: String {
        let tasksPath = "/tasks/"
        
        switch self {
        case .signUp:
            return "/signUp"
        case .signIn:
            return "/login"
        case .verify(token: let token):
            return "/verify/" + token
        case .resendEmailToken(email: let email):
            return "/users/verify/" + email
        case .getUser(userId: let userId):
            return "/users/" + userId
        case .getTasks:
            return tasksPath + "user"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .signUp:
            return .put
        case .signIn, .verify, .resendEmailToken:
            return .post
        case .getUser, .getTasks:
            return .get
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
        case .verify, .resendEmailToken, .getUser, .getTasks:
            return .requestParametersAndHeaders(bodyParameters: [:], bodyEncoding: .urlEncoding, urlParameters: nil, additionHeaders: headers)
        }
    }
    
    public var headers: HTTPHeaders {
        let localHeader = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + (Environment.shared.getUserToken() ?? "")
        ]
        
//        switch self {
//        case .login(token: let token):
//            localHeader["Authorization"] = "Bearer " + token
//        default:
//            break
//        }
        
        return localHeader
    }
    
}
