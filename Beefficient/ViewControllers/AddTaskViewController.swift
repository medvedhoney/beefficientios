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
        print(form.values())
        
        
    }

}
