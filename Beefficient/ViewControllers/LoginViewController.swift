//
//  LoginViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak fileprivate var loginField: UITextField!
    @IBOutlet weak fileprivate var passwordField: UITextField!
    @IBOutlet weak fileprivate var login: UIButton!
    @IBOutlet weak fileprivate var close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginTap() {
        
    }

}
