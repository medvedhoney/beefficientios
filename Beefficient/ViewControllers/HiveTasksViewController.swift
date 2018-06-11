//
//  HiveTasksViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 07/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class HiveTasksViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    let viewModel = HiveTasksViewModel()
    
    let cellNibName = "TaskTableViewCell"
    let taskCellId = "taskCell"
    let newTaskId = "newTaskId"

    var observations: [NSKeyValueObservation] = []
    
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
        
        configureTableView()
        viewModel.getTasks()
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: taskCellId)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
    }
    
    @objc func updateData() {
        viewModel.getTasks()
    }
}

extension HiveTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.minimalTasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: newTaskId)!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellId) as! TaskTableViewCell
        cell.populate(with: viewModel.minimalTasks[indexPath.row - 1], type: .simple)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let members = viewModel.members else { return }
            let controller = AddTaskViewController()
            controller.users = members
            controller.hive = viewModel.hive
            controller.hiveTasksViewModel = viewModel
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
