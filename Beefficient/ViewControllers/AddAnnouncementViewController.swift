//
//  AddAnnouncementViewController.swift
//  Beefficient
//
//  Created by Eugen on 11/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import Eureka

class AddAnnouncementViewController: FormViewController {
    
    var hives: [Hive]!
    
    var intervals: [String] = Array(1...24).map({ "\($0) hours" })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New announcement"
        
        setupNav()
        getHives()
    }
    
    func getHives() {
        Environment.shared.networkManager.getUserHives { [weak self] (hives, error) in
            DispatchQueue.main.async { [weak self] in
                if let hives = hives {
                    self?.hives = hives.filter({ $0.owner == Environment.shared.user?.id })
                    self?.setupForm()
                } else if let error = error {
                    self?.showError(error: error)
                }
            }
        }
    }
    
    func setupForm() {
        form +++ Section("Description")
            <<< TextRow(){ row in
                row.tag = "description"
                row.title = "Task description"
                row.placeholder = "Enter here"
            }
            <<< PushRow<String>() { [unowned self] row in
                row.tag = "interval"
                row.title = "Valid for"
                row.options = self.intervals
                row.value = "1 hours"
            }
            <<< PushRow<String>() { [unowned self] row in
                row.tag = "hive"
                row.title = "Hive"
                row.selectorTitle = "Select Hive"
                row.options = self.hives.map({ $0.name })
                row.value = self.hives.first?.name
            }
    }
    
    func setupNav() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAnn))
        
        navigationItem.rightBarButtonItems = [doneButton]
    }
    
    @objc func saveAnn() {
        let values = form.values()
        
        guard
            let hiveName = values["hive"] as? String,
            let description = values["description"] as? String
        else {
            return
        }
        
        let hiveId = hives.first(where: { $0.name == hiveName })!.name
        
        Environment.shared.networkManager.addAnnouncement(description: description, requiredAssignees: 1, status: "announcement", hive: hiveId) { [weak self] (task, error) in
            if task != nil {
                self?.navigationController?.popViewController(animated: true)
            } else if let error = error {
                self?.showError(error: error)
            }
        }
    }

}
