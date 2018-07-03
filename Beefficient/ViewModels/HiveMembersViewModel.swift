//
//  HiveMembersViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 07/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class HiveMembersViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var members: [User] = []
    var filteredMembers: [User] = []
    var minimalMembers: [MemberData] = []
    
    var hive: Hive!
    
    func configure(hive: Hive) {
        self.hive = hive
    }
    
    func getUsers() {
        env.networkManager.getHiveUsers(id: hive.id) { [weak self] (users, error) in
            guard let users = users else {
                self?.error = error
                return
            }
            
            self?.members = users
            self?.filterMembers(query: "")
        }
    }
    
    func filterMembers(query: String) {
        defer {
            minimizeMembers()
            success = true
        }
        
        guard query != "" else {
            filteredMembers = members
            return
        }
        
        filteredMembers = members.filter({ $0.name.lowercased().contains(query) })
    }
    
    func minimizeMembers() {
        minimalMembers = filteredMembers.map({ minimizeMember(user: $0) })
    }
    
    func minimizeMember(user: User) -> MemberData {
        let owner = hive.owner == env.user?.id
        let ownUser = user.id == env.user?.id
        
        return MemberData(userId: user.id!, ownerName: user.name, completed: [], owner: owner, ownUser: ownUser)
    }
    
    func deleteUser(userId: String) {
        env.networkManager.deleteUserFromHive(hiveId: hive.id, userId: userId) { [weak self] (success, error) in
            guard let success = success, success else {
                self?.error = error
                return
            }
            
            self?.getUsers()
        }
    }
    
    func inviteUser(email: String) {
        env.networkManager.invite(hiveId: hive.id, userEmail: email) { [weak self] (success, error) in
            if let error = error {
                self?.error = error
            } else if let success = success, success {
                self?.getUsers()
            }
        }
    }
    
}
