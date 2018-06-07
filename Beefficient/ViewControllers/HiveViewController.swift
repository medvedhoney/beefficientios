//
//  HiveViewController.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 07/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class HiveViewController: UIViewController {
    @IBOutlet weak fileprivate var segmentedControl: UISegmentedControl!
    @IBOutlet weak fileprivate var contentView: UIView!
    
    var selectedTab = 0
    var currentViewController: UIViewController?
    
    var hive: Hive!
    
    lazy var membersVC: UIViewController = {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "membersVC") as! HiveMembersViewController
        controller.viewModel.configure(hive: hive)
        return controller
    }()
    
    lazy var tasksVC: UIViewController  = {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "hiveTasksVC") as! HiveTasksViewController
        controller.viewModel.configure(hive: hive)
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        showController()
    }
    
    func showController() {
        let vc = selectedTab == 0 ? membersVC : tasksVC
        
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        
        currentViewController = vc
    }
    
    func hideController() {
        currentViewController!.view.removeFromSuperview()
        currentViewController!.removeFromParentViewController()
    }
    
    @IBAction func switchTabs() {
        guard segmentedControl.selectedSegmentIndex != selectedTab else {
            return
        }
        
        hideController()
        selectedTab = segmentedControl.selectedSegmentIndex
        showController()
    }

}
