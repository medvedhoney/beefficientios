//
//  TaskTableViewCell.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 01/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

enum TaskType {
    case simple, pool
}

struct TaskCellViewData {
    let id: String
    let taskTitle: String
    let time: String
    let owner: String
    let assignees: [String]
    let status: TaskStatus
    let assigneesMaxNumber: Int
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak fileprivate var taskTitle: UILabel!
    @IBOutlet weak fileprivate var time: UILabel!
    @IBOutlet weak fileprivate var owner: UILabel!
    @IBOutlet weak fileprivate var assignee: UILabel!
    @IBOutlet weak fileprivate var assigneesNumber: UILabel!
    @IBOutlet weak fileprivate var taskIcon: UIImageView!
    
    var task: TaskCellViewData!
    
    func populate(with task: TaskCellViewData, type: TaskType) {
        self.task = task
        
        switch type {
        case .simple:
            assigneesNumber.isHidden = true
        case .pool:
            assignee.superview?.isHidden = true
        }
        
        taskTitle.text = task.taskTitle
        owner.text = task.owner
        time.text = "🕒 " + task.time
        assignee.text = task.assignees.joined(separator: ", ")
        taskIcon.image = UIImage(named: task.status.image)
        assigneesNumber.text = "👤 \(task.assignees.count)/\(task.assigneesMaxNumber)"
        
    }
    
}
