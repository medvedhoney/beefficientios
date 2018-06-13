//
//  MyTasksViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 30/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

enum Filter: String {
    case all = "All"
    case owned = "Owned"
    case assignedToMe = "Assigned to me"
    case dueSoon = "Due soon"
    case done = "Done"
    
    static var values: [Filter] {
        get {
            return [.all, .owned, .assignedToMe, .dueSoon, .done]
        }
    }
}

class MyTasksViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    let viewModel = MyTasksViewModel()
    
    var observations: [NSKeyValueObservation] = []
    let cellNibName = "TaskTableViewCell"
    let taskCellId = "taskCell"
    
    let textField = UITextField()
    let dataPicker = UIPickerView()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(updateData), for: .valueChanged)
        return control
    }()

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
                self.refreshControl.endRefreshing()
            }
        }
        observations.append(observation)
        
        setupFilters()
        setupNavBar()
        
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: taskCellId)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        viewModel.getTasks()
    }
    
    @objc func updateData() {
        viewModel.getTasks()
    }
    
    func setupNavBar() {
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(showFilters))
        
        navigationItem.rightBarButtonItems = [filterButton]
    }
    
    func setupFilters() {
        view.addSubview(textField)
        textField.inputView = dataPicker
        dataPicker.dataSource = self
        dataPicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        let filter = Filter.values[dataPicker.selectedRow(inComponent: 0)]
        viewModel.filterTasks(filter: filter)
        cancelPicker()
    }
    
    @objc func cancelPicker() {
        textField.resignFirstResponder()
    }
    
    @objc func showFilters() {
        textField.becomeFirstResponder()
    }

}

extension MyTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.minimalTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellId) as! TaskTableViewCell
        cell.populate(with: viewModel.minimalTasks[indexPath.row], type: .simple)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Task", bundle: nil).instantiateInitialViewController() as! TaskViewController
        let task = viewModel.tasks.first(where: { $0.id == viewModel.minimalTasks[indexPath.row].id })!
        controller.viewModel.users = viewModel.tempUsers
        controller.viewModel.configure(task: task)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MyTasksViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Filter.values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Filter.values[row].rawValue
    }
}

extension MyTasksViewController: TaskUpdate {
    func updateTask(task: Task, deleted: Bool) {
        if let index = viewModel.tasks.index(where: { $0.id == task.id }) {
            if deleted {
                viewModel.tasks.remove(at: index)
            } else {
                viewModel.tasks[index] = task
            }
            viewModel.filterTasks(filter: .all)
        }
    }
    
}
