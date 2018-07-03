//
//  TaskViewController.swift
//  Beefficient
//
//  Created by Eugen on 28/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

protocol TaskUpdate: NSObjectProtocol {
    func updateTask(task: Task, deleted: Bool)
}

class TaskViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var messageField: UITextField!
    
    let viewModel = TaskViewModel()
    
    var observations: [NSKeyValueObservation] = []
    let messageCellId = "messageCell"
    
    weak var delegate: TaskUpdate?

    override func viewDidLoad() {
        super.viewDidLoad()

        var observation = viewModel.observe(\.error) { [unowned self] (model, change) in
            DispatchQueue.main.async { [unowned self] in
                self.showError(error: model.error)
            }
        }
        observations.append(observation)
        
        observation = viewModel.observe(\.success) { [unowned self] (model, change) in
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
        observations.append(observation)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tabBarController?.tabBar.isHidden = false
        delegate?.updateTask(task: viewModel.task, deleted: viewModel.deleted)
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        guard
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveData = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let curve = UIViewAnimationCurve(rawValue: curveData.intValue),
            let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        let newFrame = value.cgRectValue
        let keyboardFrame = view.convert(newFrame, from: nil)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height - keyboardFrame.height)
        
        UIView.commitAnimations()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveData = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let curve = UIViewAnimationCurve(rawValue: curveData.intValue),
            let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
            else {
                return
        }
        
        let newFrame = value.cgRectValue
        let keyboardFrame = view.convert(newFrame, from: nil)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height + keyboardFrame.height)
        
        UIView.commitAnimations()
    }
    
    @IBAction func postMessage() {
        guard let message = messageField.text, message.count > 0 else {
            return
        }
        
        messageField.text = nil
        viewModel.postMessage(message: message)
        view.endEditing(true)
    }
}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskActionsID") as! TaskActionsTableViewCell
        cell.delegate = self
        let owner = viewModel.task.owner == Environment.shared.user!.id
        let assigned = viewModel.task.assignee.contains(Environment.shared.user!.id!)
        let done = TaskStatus(rawValue: viewModel.task.status) == .done
        let announcement = TaskStatus(rawValue: viewModel.task.status) == .announcement
        cell.setupActions(description: viewModel.task.description, owner: owner, assigned: assigned, done: done, announcement: announcement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.minimalMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId) as! ChatMessageTableViewCell
        cell.populate(with: viewModel.minimalMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
}

extension TaskViewController: TaskActions {
    func deleteTask() {
        viewModel.deleteTask { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func reassignTask() {
        viewModel.deleteUserFromTask { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func doneTask() {
        viewModel.switchTaskStatus(status: "done")
    }
}
