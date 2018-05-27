//
//  MyTasksViewModel.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 01/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class MyTasksViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var tasks: [Task] = []
    var minimalTasks: [TaskCellViewData] = []
    
    let formatter = ISO8601DateFormatter()
    let componentFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    func getTasks() {
        env.networkManager.getMyTasks { [weak self] (tasks, error) in
            guard let tasks = tasks else {
                self?.error = error
                return
            }
            
            self?.tasks = tasks
            self?.prepareData()
        }
    }
    
    func prepareData() {
        minimalTasks = tasks.map({ (task) -> TaskCellViewData in
            <#code#>
        })
    }
    
    func minimizeTask(task: Task) -> TaskCellViewData {
        var time = ""
        if let date = formatter.date(from: task.deadline) {
            let timeInterval = date.timeIntervalSinceNow
            time = componentFormatter.string(from: timeInterval) ?? ""
        }
        
        
    }
}