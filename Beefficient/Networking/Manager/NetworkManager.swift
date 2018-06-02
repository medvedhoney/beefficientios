//
//  NetworkManager.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 17/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case connectionError = "Please check your network connection."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    let router = Router<BeefficientAPI>()
    
    func signUp(name: String, email: String, phone: String, password: String, completion: @escaping (_ auth: Authorization?, _ error: String?) -> ()) {
        router.request(.signUp(name: name, email: email, password: password, phone: phone)) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let auth = try JSONDecoder().decode(Authorization.self, from: data)
                        completion(auth, nil)
                        
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ auth: Authorization?, _ error: String?) -> ()) {
        router.request(.signIn(email: email, password: password)) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let auth = try JSONDecoder().decode(Authorization.self, from: data)
                        completion(auth, nil)
                        
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func resendEmailVerification(email: String) {
        
    }
    
    func verifyEmail(token: String, completion: @escaping (_ auth: Authorization?, _ error: String?) -> ()) {
        router.request(.verify(token: token)) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let auth = try JSONDecoder().decode(Authorization.self, from: data)
                        completion(auth, nil)
                        
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getUser(id: String, completion: @escaping (_ user: User?, _ error: String?) -> Void) {
        router.request(.getUser(userId: id)) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let requestResult = try JSONDecoder().decode(RequestResult.self, from: data)
                        completion(requestResult.user, requestResult.error)
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getMyTasks(completion: @escaping (_ tasks: [Task]?, _ error: String?) -> Void) {
        router.request(.getTasks) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let requestResult = try JSONDecoder().decode(RequestResult.self, from: data)
                        completion(requestResult.tasks, requestResult.error)
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func postChatMessage(message: String, taskId: String, completion: @escaping (_ tasks: Task?, _ error: String?) -> Void) {
        router.request(.postMessage(message: message, taskId: taskId)) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let requestResult = try JSONDecoder().decode(RequestResult.self, from: data)
                        completion(requestResult.task, requestResult.error)
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getPool(completion: @escaping (_ tasks: [Task]?, _ error: String?) -> Void) {
        router.request(.getPool) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let requestResult = try JSONDecoder().decode(RequestResult.self, from: data)
                        completion(requestResult.tasks, requestResult.error)
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func assignUsers(taskId: String, userIds: [String], completion: @escaping (_ task: Task?, _ error: String?) -> Void) {
        router.request(.assignTask(userIds: userIds, taskId: taskId)) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let requestResult = try JSONDecoder().decode(RequestResult.self, from: data)
                        completion(requestResult.task, requestResult.error)
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getUserHives(completion: @escaping (_ hives: [Hive]?, _ error: String?) -> Void) {
        router.request(.getUserHives) { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkResponse.connectionError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let requestResult = try JSONDecoder().decode(RequestResult.self, from: data)
                        completion(requestResult.hives, requestResult.error)
                    } catch (let error) {
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
