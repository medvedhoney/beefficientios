//
//  TaskTableViewCell.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 01/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

struct TaskCellViewData {
    let taskTitle: String
    let time: String
    let owner: String
    let assignees: [String]
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak fileprivate var taskTitle: UILabel!
    @IBOutlet weak fileprivate var time: UILabel!
    @IBOutlet weak fileprivate var owner: UILabel!
    @IBOutlet weak fileprivate var assignee: UILabel!
    
    var task: TaskCellViewData!
    
    func populate(with task: TaskCellViewData) {
        self.task = task
        
        taskTitle.text = task.taskTitle
        owner.text = task.owner
        time.text = task.time
        assignee.text = task.assignees.joined(separator: ", ")
    }

}
