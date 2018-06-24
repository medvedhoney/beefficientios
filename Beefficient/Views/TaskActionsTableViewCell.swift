//
//  TaskActionsTableViewCell.swift
//  Beefficient
//
//  Created by Eugen on 13/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

protocol TaskActions: NSObjectProtocol {
    func deleteTask()
    func reassignTask()
    func doneTask()
}

class TaskActionsTableViewCell: UITableViewCell {
    @IBOutlet weak fileprivate var taskDescription: UILabel!
    @IBOutlet weak fileprivate var deleteView: UIView!
    @IBOutlet weak fileprivate var reassignView: UIView!
    @IBOutlet weak fileprivate var doneView: UIView!
    
    weak var delegate: TaskActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupActions(description: String, owner: Bool, assigned: Bool, done: Bool, announcement: Bool) {
        taskDescription.text = description
        deleteView.isHidden = !owner
        reassignView.isHidden = !assigned || announcement
        doneView.isHidden = done || announcement
        
        deleteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteTask)))
        reassignView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reassignTask)))
        doneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneTask)))
    }
    
    @objc func deleteTask() {
        delegate?.deleteTask()
    }
    
    @objc func reassignTask() {
        delegate?.reassignTask()
    }
    
    @objc func doneTask() {
        delegate?.doneTask()
    }

}
