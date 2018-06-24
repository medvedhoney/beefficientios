//
//  PoolViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 01/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class PoolViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var tasks: [Task] = []
    var minimalTasks: [TaskCellViewData] = []
    
    let timeWork = TimeWork()
    
    func getPool() {
        env.networkManager.getPool { [weak self] (tasks, error) in
            guard let tasks = tasks else {
                self?.error = error
                return
            }
            
            self?.tasks = tasks
            self?.prepareData()
            self?.success = true
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
        let owner = task.owner
        let taskTitle = task.description
        let assignees: [String] = task.assignee
        let status = TaskStatus(rawValue: task.status) ?? .active
        let requiredAssignees = task.requiredAssignees
        
        return TaskCellViewData(id: task.id, taskTitle: taskTitle, time: time, owner: owner, assignees: assignees, status: status, assigneesMaxNumber: requiredAssignees)
    }
    
    func assignTask(task: Task) {
        guard let userId = env.user?.id else { return }
        
        let taskId = task.id
        var userIds = task.assignee
        
        if !userIds.contains(userId) {
            userIds.append(userId)
        }
        
        env.networkManager.assignUsers(taskId: taskId, userIds: userIds) { [weak self] (_, error) in
            if let error = error {
                self?.error = error
            } else {
                self?.getPool()
            }
        }
    }
}
