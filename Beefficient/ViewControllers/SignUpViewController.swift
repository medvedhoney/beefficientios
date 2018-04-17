//
//  SignUpViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak fileprivate var name: UITextField!
    @IBOutlet weak fileprivate var email: UITextField!
    @IBOutlet weak fileprivate var phoneNumber: UITextField!
    @IBOutlet weak fileprivate var password: UITextField!
    @IBOutlet weak fileprivate var confirmPassword: UITextField!
    @IBOutlet weak fileprivate var signUp: UIButton!
    @IBOutlet weak fileprivate var close: UIButton!
    
    let viewModel = SignUpViewModel()
    
    var observation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observation = viewModel.observe(\.validData) { [unowned self] (model, change) in
            self.signUp.isEnabled = model.validData
        }
        
        setupTextFields()
    }
    
    func setupTextFields() {
        let fields: [UITextField] = [name, email, phoneNumber, password, confirmPassword]
        
        for field in fields {
            field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.validateData(name: name.text, email: email.text, phone: phoneNumber.text, password: password.text, repeatedPassword: confirmPassword.text)
    }
    
    @IBAction func registerTap() {
        
    }
    
}
