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
    case getPool
    case postMessage(message: String, taskId: String)
    case assignTask(userIds: [String], taskId: String)
    case getUserHives
    case createHive(name: String)
    case deleteHive(hiveId: String)
    case getHive(name: String)
    case joinHive(hiveId: String)
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
        case .postMessage(message: _, taskId: let id):
            return "tasks/\(id)/chat"
        case .getPool:
            return "tasks/pool"
        case .assignTask(userIds: _, taskId: let taskId):
            return "tasks/\(taskId)/assignee"
        case .getUserHives:
            return "hives/user"
        case .createHive:
            return "hives"
        case .deleteHive(hiveId: let hiveId):
            return "hives/\(hiveId)"
        case .getHive(name: let name):
            return "hives/name/\(name)"
        case .joinHive(hiveId: let hiveId):
            return "hives/\(hiveId)/request"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .signUp, .createHive:
            return .put
        case .signIn, .verify, .resendEmailToken, .postMessage, .assignTask, .joinHive:
            return .post
        case .getUser, .getTasks, .getPool, .getUserHives, .getHive:
            return .get
        case .deleteHive:
            return .delete
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
        case .postMessage(message: let message, taskId: _):
            return .requestParametersAndHeaders(bodyParameters: [
                "message": message,
                ], bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        case .assignTask(userIds: let userIds, taskId: _):
            return .requestParametersAndHeaders(bodyParameters: [
                "assignee": userIds,
                ], bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        case .createHive(name: let name):
            return .requestParametersAndHeaders(bodyParameters: [
                "name": name,
                ], bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        case .verify, .resendEmailToken, .getUser, .getTasks, .getPool, .getUserHives, .deleteHive, .getHive, .joinHive:
            return .requestParametersAndHeaders(bodyParameters: [:], bodyEncoding: .urlEncoding, urlParameters: nil, additionHeaders: headers)
        }
    }
    
    public var headers: HTTPHeaders {
        let localHeader = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + (Environment.shared.getUserToken() ?? "")
        ]
        
        return localHeader
    }
    
}
