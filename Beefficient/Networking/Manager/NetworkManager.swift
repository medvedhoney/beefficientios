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

class NetworkManager {
    let router = Router<BeefficientAPI>()
    
    func performRequest(data: Data?, response: URLResponse?, error: Error?) -> (RequestResult?, String?) {
        guard error == nil else {
            return (nil, NetworkResponse.connectionError.rawValue)
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let data = data else {
                    return (nil, NetworkResponse.noData.rawValue)
                }
                
                do {
                    let requestResult = try JSONDecoder().decode(RequestResult.self, from: data)
                    return (requestResult, requestResult.error)
                    
                } catch (let error) {
                    print(error)
                }
                
            case .failure(let error):
                return (nil, error)
            }
        }
        
        return (nil, nil)
    }
    
    func signUp(name: String, email: String, phone: String, password: String, completion: @escaping (_ user: User?, _ error: String?) -> ()) {
        router.request(.signUp(name: name, email: email, password: password, phone: phone)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.user, error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ user: User?, _ token: String?, _ error: String?) -> ()) {
        router.request(.signIn(email: email, password: password)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.user, requestResult?.token, error)
        }
    }
    
    func resendEmailVerification(email: String) {
        
    }
    
    func verifyEmail(token: String, completion: @escaping (_ user: User?, _ error: String?) -> ()) {
        router.request(.verify(token: token)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.user, error)
        }
    }
    
    func getUser(id: String, completion: @escaping (_ user: User?, _ error: String?) -> Void) {
        router.request(.getUser(userId: id)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.user, error)
        }
    }
    
    func getMyTasks(completion: @escaping (_ tasks: [Task]?, _ error: String?) -> Void) {
        router.request(.getTasks) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.tasks, error)
        }
    }
    
    func postChatMessage(message: String, taskId: String, completion: @escaping (_ tasks: Task?, _ error: String?) -> Void) {
        router.request(.postMessage(message: message, taskId: taskId)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.task, error)
        }
    }
    
    func getPool(completion: @escaping (_ tasks: [Task]?, _ error: String?) -> Void) {
        router.request(.getPool) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.tasks, error)
        }
    }
    
    func assignUsers(taskId: String, userIds: [String], completion: @escaping (_ task: Task?, _ error: String?) -> Void) {
        router.request(.assignTask(userIds: userIds, taskId: taskId)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.task, error)
        }
    }
    
    func getUserHives(completion: @escaping (_ hives: [Hive]?, _ error: String?) -> Void) {
        router.request(.getUserHives) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.hives, error)
        }
    }
    
    func createHive(name: String, completion: @escaping (_ hive: Hive?, _ error: String?) -> Void) {
        router.request(.createHive(name: name)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.hive, error)
        }
    }
    
    func getHive(name: String, completion: @escaping (_ hive: Hive?, _ error: String?) -> Void) {
        router.request(.getHive(name: name)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.hive, error)
        }
    }
    
    func joinHive(id: String, completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        router.request(.joinHive(hiveId: id)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.result, error)
        }
    }
    
    func deleteHive(id: String, completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        router.request(.deleteHive(hiveId: id)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.result, error)
        }
    }
    
    func getHiveUsers(id: String, completion: @escaping (_ users: [User]?, _ error: String?) -> Void) {
        router.request(.getHiveUsers(hiveId: id)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.users, error)
        }
    }
    
    func deleteUserFromHive(hiveId: String, userId: String, completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        router.request(.deleteUserFromHive(hiveId: hiveId, userId: userId)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.result, error)
        }
    }
    
    func getPublicHiveTasks(hiveId: String, completion: @escaping (_ tasks: [Task]?, _ error: String?) -> Void) {
        router.request(.getPublicHiveTasks(hiveId: hiveId)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.tasks, error)
        }
    }
    
    func updateUser(parameters: [String: String], completion: @escaping (_ tasks: User?, _ error: String?) -> Void) {
        router.request(.updateUser(parameters: parameters)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.user, error)
        }
    }
    
    func addTask(description: String, requiredAssignees: Int, status: String, assignee: [String], deadline: String, privacy: Bool, hive: String, completion: @escaping (_ task: Task?, _ error: String?) -> Void) {
        router.request(.addTask(description: description, requiredAssignees: requiredAssignees, status: status, assignee: assignee, deadline: deadline, privacy: privacy, hive: hive)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.task, error)
        }
    }
    
    func addAnnouncement(description: String, requiredAssignees: Int, status: String, hive: String, completion: @escaping (_ task: Task?, _ error: String?) -> Void) {
        router.request(.addAnnouncement(description: description, requiredAssignees: requiredAssignees, status: status, hive: hive)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.task, error)
        }
    }
    
    func logout(completion: @escaping (_ result: Bool?, _ error: String?) -> Void) {
        router.request(.logout) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.result, error)
        }
    }
    
    func deleteTask(taskId: String, completion: @escaping (_ result: Bool?, _ error: String?) -> Void) {
        router.request(.deleteTask(taskId: taskId)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.result, error)
        }
    }
    
    func switchTaskStatus(taskId: String, status: String, completion: @escaping (_ result: Task?, _ error: String?) -> Void) {
        router.request(.switchTaskStatus(taskId: taskId, status: status)) { [unowned self] (data, response, error) in
            let (requestResult, error) = self.performRequest(data: data, response: response, error: error)
            completion(requestResult?.task, error)
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
