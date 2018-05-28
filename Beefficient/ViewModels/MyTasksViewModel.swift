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
    
    func getTasks() {
        env.networkManager.getMyTasks { [weak self] (tasks, error) in
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
        let assignees: [String] = []
        let status = TaskStatus(rawValue: task.status) ?? .active
        let requiredAssignees = task.requiredAssignees
        
        return TaskCellViewData(taskTitle: taskTitle, time: time, owner: owner, assignees: assignees, status: status, assigneesMaxNumber: requiredAssignees)
    }
}
