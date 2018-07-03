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
        return viewModel.minimalMembers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNewMemberID")!
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! MemberTableViewCell
        cell.populate(with: viewModel.minimalMembers[indexPath.row - 1])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        
        let title = "Invite a new member to the hive"
        
        let cancelHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let controller = alert(title: title, message: nil, buttons: [(title: "Cancel", style: .cancel, handler: cancelHandler)], completion: nil) as! UIAlertController
        
        controller.addTextField { (textField) in
            textField.placeholder = "Friend's email"
        }
        
        let createButton = UIAlertAction(title: "Send invite", style: .default) { [unowned self] (_) in
            let field = controller.textFields![0]
            if let email = field.text, email != "" {
                self.viewModel.inviteUser(email: email)
            }
        }
        
        controller.addAction(createButton)
        
        present(controller, animated: true, completion: nil)
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
        guard let number = viewModel.members.first(where: { $0.id == userId })?.phone,
            let url = URL(string: "tel://" + number)
            else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
