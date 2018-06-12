//
//  SettingsViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 09/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!

    let viewModel = SettingsViewModel()
    
    let settingsHeaderId = "settingsHeaderId"
    let settingsCell = "settingsCell"
    
    var observations: [NSKeyValueObservation] = []
    
    var settingsData: [(title: String, placeholder: String)] = [
        ("Change name", "Insert new name"),
        ("Change email", "Insert new email"),
        ("Change phone", "Insert new phone"),
        ("Change password", "Insert new password")
    ]
    
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
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 120
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: settingsHeaderId)!
            return cell
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.dataSource.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCell) as! SettingsTableViewCell
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "New announcement"
            cell.img.image = #imageLiteral(resourceName: "announcement-icon")
            return cell
        case 1:
            cell.titleLabel.text = viewModel.dataSource[indexPath.row].value
            cell.img.image = UIImage(named: viewModel.dataSource[indexPath.row].key)
            cell.img.tintColor = UIColor(rgb: 0xF48418)
            return cell
        case 2:
            cell.titleLabel.text = "Logout"
            cell.img.image = #imageLiteral(resourceName: "logout")
            cell.img.tintColor = UIColor(rgb: 0xF48418)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let controller = AddAnnouncementViewController()
            navigationController?.pushViewController(controller, animated: true)
        case 1:
            showSettingsAlert(index: indexPath.row, key: viewModel.dataSource[indexPath.row].key)
        case 2:
            viewModel.logout()
            let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = controller
        default:
            break
        }
    }
    
    func showSettingsAlert(index: Int, key: String) {
        let title = settingsData[index].title
        
        let cancelHandler: ((UIAlertAction) -> Void) = { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let controller = alert(title: title, message: nil, buttons: [(title: "Cancel", style: .cancel, handler: cancelHandler)], completion: nil) as! UIAlertController
        
        controller.addTextField { [unowned self] (textField) in
            textField.placeholder = self.settingsData[index].placeholder
        }
        
        let createButton = UIAlertAction(title: "Change", style: .default) { [unowned self] (_) in
            let field = controller.textFields![0]
            if let name = field.text, name != "" {
                self.viewModel.updateUser(key: key, value: name)
            }
        }
        
        controller.addAction(createButton)
        
        present(controller, animated: true, completion: nil)
    }
}
