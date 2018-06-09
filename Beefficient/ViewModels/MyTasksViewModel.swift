//
//  MyTasksViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 01/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

enum TaskStatus: String {
    case announcement = "announcement", active = "active", done = "done", progress = "progress"
    
    var image: String {
        switch self {
        case .announcement:
            return "announcement"
        case .active:
            return "task-moderate"
        case .done:
            return "task-complete"
        case .progress:
            return "inprogress-icon"
        }
    }
}

@objcMembers class MyTasksViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var tasks: [Task] = []
    var minimalTasks: [TaskCellViewData] = []
    
    let timeWork = TimeWork()
    
    var userIds: Set<String> = []
    var tempUsers: [String: User] = [:]
    
    func getTasks() {
        env.networkManager.getMyTasks { [weak self] (tasks, error) in
            guard let tasks = tasks else {
                self?.error = error
                return
            }
            
            self?.tasks = tasks
            tasks.forEach({ task in
                task.assignee.forEach({ self?.userIds.insert($0) })
                self?.userIds.insert(task.owner)
            })
            
            self?.getUsers()
        }
    }
    
    func prepareData() {
        minimalTasks = tasks.map({ (task) -> TaskCellViewData in
            return minimizeTask(task: task)
        })
    }
    
    func minimizeTask(task: Task) -> TaskCellViewData {
        let date = timeWork.dateFromString(task.deadline)
        let time = timeWork.formattedIntervalSinceNow(date)
        let owner = tempUsers[task.owner]?.name ?? ""
        let taskTitle = task.description
        let assignees: [String] = task.assignee.compactMap({ tempUsers[$0]?.name })
        let status = TaskStatus(rawValue: task.status) ?? .active
        let requiredAssignees = task.requiredAssignees
        
        return TaskCellViewData(taskTitle: taskTitle, time: time, owner: owner, assignees: assignees, status: status, assigneesMaxNumber: requiredAssignees)
    }
    
    func getUsers() {
        let dispatchGroup = DispatchGroup()
        userIds.forEach({ self.getUser(id: $0, dispatchGroup: dispatchGroup) })
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.prepareData()
            self?.success = true
        }
    }
    
    func getUser(id: String, dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).sync { [unowned self] in
            self.env.networkManager.getUser(id: id, completion: { [weak self] (user, error) in
                defer {
                    dispatchGroup.leave()
                }
                guard let user = user else { return }
                self?.tempUsers[user.id] = user
            })
        }
    }
}
