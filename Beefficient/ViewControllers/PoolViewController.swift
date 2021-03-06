//
//  PoolViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 01/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class PoolViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    let viewModel = PoolViewModel()
    
    var observations: [NSKeyValueObservation] = []
    let taskCellId = "taskCell"
    let cellNibName = "TaskTableViewCell"
    
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
        
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: taskCellId)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        viewModel.getPool()
    }
    
    @objc func updateData() {
        viewModel.getPool()
    }

}

extension PoolViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.minimalTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellId) as! TaskTableViewCell
        cell.populate(with: viewModel.minimalTasks[indexPath.row], type: .pool)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard TaskStatus(rawValue: viewModel.tasks[indexPath.row].status) != TaskStatus.announcement else {
            return
        }
        
        let title = "Do you want to take this task?"
        let description = viewModel.tasks[indexPath.row].description
        
        let yesHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.viewModel.assignTask(task: self.viewModel.tasks[indexPath.row])
        }
        let noHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let controller = alert(title: title, message: description, buttons: [(title: "No", style: .cancel, handler: noHandler),(title: "Yes", style: .default, handler: yesHandler)], completion: nil)
        
        present(controller, animated: true, completion: nil)
    }
}
