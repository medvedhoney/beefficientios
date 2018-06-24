//
//  AddTaskViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 09/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import Eureka

class AddTaskViewController: FormViewController {
    var hive: Hive!
    var users: [User]!
    var hiveTasksViewModel: HiveTasksViewModel!
    
    let timeWork = TimeWork()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()

        form +++ Section("Description")
            <<< TextRow(){ row in
                row.tag = "description"
                row.title = "Task description"
                row.placeholder = "Enter here"
            }
            <<< SliderRow() { row in
                row.tag = "assigneesNumber"
                row.title = "Assignees Number"
                row.maximumValue = 10
                row.minimumValue = 1
                row.value = 5
                row.steps = 9
            }
            <<< MultipleSelectorRow<String>() { [unowned self] row in
                row.tag = "assignees"
                row.title = "Assignees"
                row.options = self.users.map({ $0.name })
            }
            +++ Section("Schedule")
            <<< DateRow(){
                $0.tag = "date"
                $0.title = "Due at"
                $0.value = Date()
            }
            <<< TimeRow() { row in
                row.tag = "time"
                row.title = "Time"
            }
            +++ Section("Status")
            <<< CheckRow() { row in
                row.tag = "status"
                row.title = "Private"
            }
    }
    
    func setupNav() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveTask))
        
        navigationItem.rightBarButtonItems = [doneButton]
    }
    
    @objc func saveTask() {
        let values = form.values()
        guard
            let description = values["description"] as? String,
            let assigneesNumber = values["assigneesNumber"] as? Float,
            let date = values["date"] as? Date,
            let time = values["time"] as? Date
            else {
                return
        }
        
        let assignees = values["assignees"] as? Set<String> ?? []
        let status = (values["status"] as? Bool) ?? false
        var userIds: [String] = []
        
        assignees.forEach({ user in
            if let userId = self.users.first(where: { $0.name == user })?.id {
                userIds.append(userId)
            }
        })
        
        let timeInterval = time.timeIntervalSince(Calendar.current.startOfDay(for: time))
        let deadline = Calendar.current.startOfDay(for: date).addingTimeInterval(timeInterval)
        
        let deadlineString = timeWork.formatter.string(from: deadline)
        
        Environment.shared.networkManager.addTask(description: description, requiredAssignees: Int(assigneesNumber), status: "active", assignee: userIds, deadline: deadlineString, privacy: status, hive: hive.id) { [weak self] (task, error) in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.showError(error: error)
                    return
                } else {
                    self?.hiveTasksViewModel.getTasks()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

}
