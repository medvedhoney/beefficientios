//
//  HiveMembersViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 07/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class HiveMembersViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!

    let viewModel = HiveMembersViewModel()
    
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
        viewModel.getUsers()
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
    }
    
    @objc func updateData() {
        viewModel.getUsers()
    }
}

extension HiveMembersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.minimalMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! MemberTableViewCell
        cell.populate(with: viewModel.minimalMembers[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension HiveMembersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterMembers(query: searchText.lowercased())
    }
}

extension HiveMembersViewController: MemberProtocol {
    func deleteUser(userId: String) {
        let title = "Do you really want to delete member?"
        
        let yesHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.viewModel.deleteUser(userId: userId)
        }
        let noHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let controller = alert(title: title, message: nil, buttons: [(title: "No", style: .cancel, handler: noHandler),(title: "Yes", style: .default, handler: yesHandler)], completion: nil)
        
        present(controller, animated: true, completion: nil)
    }
    
    func callUser(userId: String) {
        guard let number = viewModel.members.first(where: { $0.id == userId })?.phone else { return }
        let controller = alert(title: number, message: nil, buttons: [okButton], completion: nil)
        present(controller, animated: true, completion: nil)
    }
}
