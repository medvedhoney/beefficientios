//
//  MyTasksViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 30/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class MyTasksViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    let viewModel = MyTasksViewModel()
    
    var observations: [NSKeyValueObservation] = []
    let taskCellId = "taskCell"

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
        
        setupNavBar()
        tableView.tableFooterView = UIView()
        viewModel.getTasks()
    }
    
    func setupNavBar() {
        let filterButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showFilters))
        
        navigationItem.rightBarButtonItems = [filterButton]
    }
    
    @objc func showFilters() {
        
    }

}

extension MyTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellId) as! TaskTableViewCell
        cell.populate(with: viewModel.minimalTasks[indexPath.row], type: .simple)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Task", bundle: nil).instantiateInitialViewController() as! TaskViewController
        controller.viewModel.configure(task: viewModel.tasks[indexPath.row])
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MyTasksViewController: TaskUpdate {
    func updateTask(task: Task) {
        if let index = viewModel.tasks.index(where: { $0.id == task.id }) {
            viewModel.tasks[index] = task
            tableView.reloadData()
        }
    }
    
}
