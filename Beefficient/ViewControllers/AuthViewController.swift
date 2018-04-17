//
//  AuthViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak fileprivate var login: UIButton!
    @IBOutlet weak fileprivate var signUp: UIButton!
    
    let loginSegue = "signIn"
    let signUpSegue = "signUp"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginTap() {
        performSegue(withIdentifier: loginSegue, sender: nil)
    }
    
    @IBAction func registerTap() {
        performSegue(withIdentifier: signUpSegue, sender: nil)
    }

}
