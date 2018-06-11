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
    var filteredTasks: [Task] = []
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
            self?.filteredTasks = tasks
            tasks.forEach({ task in
                task.assignee.forEach({ self?.userIds.insert($0) })
                self?.userIds.insert(task.owner)
            })
            
            self?.getUsers()
        }
    }
    
    func prepareData() {
        minimalTasks = filteredTasks.map({ (task) -> TaskCellViewData in
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
        
        return TaskCellViewData(id: task.id, taskTitle: taskTitle, time: time, owner: owner, assignees: assignees, status: status, assigneesMaxNumber: requiredAssignees)
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
    
    func filterTasks(filter: Filter) {
        switch filter {
        case .all:
            filteredTasks = tasks
        case .owned:
            filteredTasks = tasks.filter({ $0.owner == env.user?.id })
        case .assignedToMe:
            filteredTasks = tasks.filter({ $0.assignee.contains(env.user?.id ?? "") })
        case .done:
            filteredTasks = tasks.filter({ TaskStatus(rawValue: $0.status) == .done })
        case .dueSoon:
            let margin = Date().addingTimeInterval(24 * 60 * 60)
            filteredTasks = tasks.filter({ task in
                guard let deadline = timeWork.formatter.date(from: task.deadline) else { return false }
                return deadline < margin
            })
        }
        
        prepareData()
        success = true
    }
}
