//
//  TaskViewController.swift
//  Beefficient
//
//  Created by Eugen on 28/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    let viewModel = TaskViewModel()
    
    var observations: [NSKeyValueObservation] = []
    let messageCellId = "messageCell"

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
        
    }

}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.minimalMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId) as! ChatMessageTableViewCell
        cell.populate(with: viewModel.minimalMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ChatMessageTableViewCell else { return }
        
        cell.setCorners(type: viewModel.minimalMessages[indexPath.row].type)
    }
    
}
