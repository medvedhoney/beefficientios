//
//  HivesViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 02/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class HivesViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    let viewModel = HivesViewModel()
    
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
        
        viewModel.getHives()
    }
    
}

extension HivesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.imageView?.image = #imageLiteral(resourceName: "hive-icon")
        cell.textLabel?.text = viewModel.hives[indexPath.row].name
        return cell
    }
}
