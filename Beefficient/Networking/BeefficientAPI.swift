//
//  BeefficientAPI.swift
//  Beefficient
//
//  Created by Eugen on 27/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation
import Moya

public var BeefficientProvider = MoyaProvider<BeefficientAPI>(
    endpointClosure: endpointClosure,
    requestClosure:requestClosure,
    plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)]
)

public func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        done(.success(request))
    } catch {
        // done(.failure(MoyaError.underlying(error, <#Response?#>)))
    }
}

let endpointClosure = { (target: BeefficientAPI) -> Endpoint in
    return MoyaProvider.defaultEndpointMapping(for: target)
}

public enum BeefficientAPI {
    case signUp(name: String, email: String, password: String, phone: String)
}

extension BeefficientAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "http://localhost:8000")!
    }
    
    public var path: String {
        switch self {
        case .signUp(name: _, email: _, password: _, phone: _):
            return "/singUp"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signUp(name: _, email: _, password: _, phone: _):
            return .put
        }
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .signUp(let name, let email, let password, let phone):
            let params: [String : Any] = [
                "name": name,
                "email": email,
                "password": password,
                "phone": phone
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
