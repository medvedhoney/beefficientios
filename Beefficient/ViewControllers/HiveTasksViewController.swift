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

    var observations: [NSKeyValueObservation] = []
    
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
        
        configureTableView()
        viewModel.getTasks()
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: taskCellId)
        tableView.tableFooterView = UIView()
    }
}

extension HiveTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.minimalTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellId) as! TaskTableViewCell
        cell.populate(with: viewModel.minimalTasks[indexPath.row], type: .simple)
        return cell
    }
}
