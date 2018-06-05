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
        
        observation = viewModel.observe(\.message) { [unowned self] (model, change) in
            DispatchQueue.main.async { [unowned self] in
                self.showSuccess(message: model.message)
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
        viewModel.getHives()
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: "HivesHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "hivesHeader")
        tableView.sectionHeaderHeight = 90
        tableView.tableFooterView = UIView()
    }
    
}

extension HivesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "hivesHeader") as! HivesHeaderTableViewCell
        view.delegate = self
        view.configure()
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredHives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.imageView?.image = #imageLiteral(resourceName: "hive-icon")
        cell.textLabel?.text = viewModel.filteredHives[indexPath.row].name
        return cell
    }
}

extension HivesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterHives(query: searchText.lowercased())
    }
}

extension HivesViewController: HiveActions {
    func createHive() {
        let title = "Create new hive"
        
        let cancelHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let controller = alert(title: title, message: nil, buttons: [(title: "Cancel", style: .cancel, handler: cancelHandler)], completion: nil) as! UIAlertController
        
        controller.addTextField { (textField) in
            textField.placeholder = "Hive name"
        }
        
        let createButton = UIAlertAction(title: "Create", style: .default) { [unowned self] (_) in
            let field = controller.textFields![0]
            if let name = field.text, name != "" {
                self.viewModel.createHive(name: name)
            }
        }
        
        controller.addAction(createButton)
        
        present(controller, animated: true, completion: nil)
    }
    
    func joinHive() {
        let title = "Send request to join hive"
        
        let cancelHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let controller = alert(title: title, message: nil, buttons: [(title: "Cancel", style: .cancel, handler: cancelHandler)], completion: nil) as! UIAlertController
        
        controller.addTextField { (textField) in
            textField.placeholder = "Hive name"
        }
        
        let createButton = UIAlertAction(title: "Send request", style: .default) { [unowned self] (_) in
            let field = controller.textFields![0]
            if let name = field.text, name != "" {
                self.viewModel.joinHive(name: name)
            }
        }
        
        controller.addAction(createButton)
        
        present(controller, animated: true, completion: nil)
    }
    
    func useInvite() {
        let title = "Add invite"
        let message = "Please add the invite code"
        
        let cancelHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let controller = alert(title: title, message: message, buttons: [(title: "Cancel", style: .cancel, handler: cancelHandler)], completion: nil) as! UIAlertController
        
        controller.addTextField { (textField) in
            textField.placeholder = "Enter code"
        }
        
        let createButton = UIAlertAction(title: "Ok", style: .default) { [unowned self] (_) in
            let field = controller.textFields![0]
            if let invite = field.text, invite != "" {
//                self.viewModel.us
            }
        }
        
        controller.addAction(createButton)
        
        present(controller, animated: true, completion: nil)
    }
    
}
