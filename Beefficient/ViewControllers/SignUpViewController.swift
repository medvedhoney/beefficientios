//
//  SignUpViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak fileprivate var name: AuthTextField!
    @IBOutlet weak fileprivate var email: AuthTextField!
    @IBOutlet weak fileprivate var phoneNumber: AuthTextField!
    @IBOutlet weak fileprivate var password: AuthTextField!
    @IBOutlet weak fileprivate var confirmPassword: AuthTextField!
    @IBOutlet weak fileprivate var signUp: UIButton!
    @IBOutlet weak fileprivate var close: UIButton!
    
    let viewModel = SignUpViewModel()
    
    var observations: [NSKeyValueObservation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var observation = viewModel.observe(\.validData) { [unowned self] (model, change) in
            self.signUp.isEnabled = model.validData
        }
        observations.append(observation)
        
        observation = viewModel.observe(\.error) { [unowned self] (model, change) in
            self.showError(error: model.error)
        }
        observations.append(observation)
        
        observation = viewModel.observe(\.success) { [unowned self] (model, change) in
            self.navigationController?.popViewController(animated: true)
        }
        observations.append(observation)
        
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
        viewModel.signUp(name: name.text!, email: email.text!, phone: phoneNumber.text!, password: password.text!)
    }
    
    @IBAction func closeTap() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
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
