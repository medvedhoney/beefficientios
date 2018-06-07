//
//  HiveTasksViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 07/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class HiveTasksViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var tasks: [Task] = []
    var minimalTasks: [TaskCellViewData] = []
    
    let timeWork = TimeWork()
    
    var hive: Hive!
    
    func configure(hive: Hive) {
        self.hive = hive
    }
    
    func getTasks() {
        env.networkManager.getPublicHiveTasks(hiveId: hive.id) { [weak self] (tasks, error) in
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
