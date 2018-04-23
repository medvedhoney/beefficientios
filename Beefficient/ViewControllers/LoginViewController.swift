//
//  LoginViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak fileprivate var loginField: AuthTextField!
    @IBOutlet weak fileprivate var passwordField: AuthTextField!
    @IBOutlet weak fileprivate var login: UIButton!
    @IBOutlet weak fileprivate var close: UIButton!
    
    let viewModel = LoginViewModel()
    
    let mainSegue = "mainSegue"
    let verifySegue = "verifyAccount"
    
    var observations: [NSKeyValueObservation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Environment.shared.user {
            loginField.text = user.email
        }
        
        var observation = viewModel.observe(\.success) { [unowned self] (model, change) in
            if Environment.shared.user?.verified == true {
                let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                self.performSegue(withIdentifier: self.verifySegue, sender: nil)
            }
        }
        observations.append(observation)
        
        observation = viewModel.observe(\.error) { [unowned self] (model, change) in
            self.showError(error: model.error)
        }
        observations.append(observation)
    }
    
    @IBAction func closeTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginTap() {
        guard let email = loginField.text, let password = passwordField.text else {
            return
        }
        
        viewModel.signIn(email: email, password: password)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let field = textField as? AuthTextField else {
            return
        }
        
        field.setHighlightedState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = textField as? AuthTextField else {
            return
        }
        
        field.setNormalState()
    }
}
