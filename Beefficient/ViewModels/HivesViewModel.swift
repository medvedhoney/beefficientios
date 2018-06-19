//
//  HivesViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 02/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class HivesViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    dynamic var message: String?
    
    var hives: [Hive] = []
    var filteredHives: [Hive] = []
    
    func getHives() {
        env.networkManager.getUserHives { [weak self] (hives, error) in
            guard let hives = hives else {
                self?.error = error
                return
            }
            
            self?.hives = hives
            self?.filterHives(query: "")
            self?.success = true
        }
    }
    
    func filterHives(query: String) {
        defer { success = true }
        guard query != "" else {
            filteredHives = hives
            return
        }
        
        filteredHives = hives.filter({ $0.name.contains(query) })
    }
    
    func deleteHive(id: String) {
        guard let index = hives.index(where: { $0.id == id }) else { return }
        
        env.networkManager.deleteHive(id: id) { [weak self] (success, error) in
            if let error = error {
                self?.error = error
            } else if let success = success, success {
                self?.hives.remove(at: index)
                self?.filterHives(query: "")
            }
        }
        
    }
    
    func createHive(name: String) {
        env.networkManager.createHive(name: name) { [weak self] (hive, error) in
            if let hive = hive {
                self?.hives.append(hive)
                self?.filterHives(query: "")
            } else if let error = error {
                self?.error = error
            }
        }
    }
    
    func joinHive(name: String) {
        env.networkManager.getHive(name: name) { [weak self] (hive, error) in
            if let hive = hive {
                self?.sendJoiningRequest(id: hive.id)
            } else if let error = error {
                self?.error = error
            }
        }
    }
    
    func sendJoiningRequest(id: String) {
        env.networkManager.joinHive(id: id) { [weak self] (success, error) in
            if let success = success, success {
                self?.message = "Request sent"
            } else if let error = error {
                self?.error = error
            }
        }
    }
    
    func useInvite(invite: String) {
        env.networkManager.acceptInvite(invite: invite) { [weak self] (hive, error) in
            if let error = error {
                self?.error = error
            } else if let hive = hive {
                self?.hives.append(hive)
                self?.filterHives(query: "")
            } else {
                self?.error = "Invalid invitation code!"
            }
        }
    }
}
