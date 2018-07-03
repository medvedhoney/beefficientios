//
//  VerifyViewController.swift
//  Beefficient
//
//  Created by Eugen on 23/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
    @IBOutlet weak fileprivate var tokenField: AuthTextField!
    
    let viewModel = VerifyViewModel()
    
    var observations: [NSKeyValueObservation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        var observation = viewModel.observe(\.success) { [unowned self] (model, change) in
            self.navigationController?.popViewController(animated: true)
        }
        observations.append(observation)
        
        observation = viewModel.observe(\.error) { [unowned self] (model, change) in
            self.showError(error: model.error)
        }
        observations.append(observation)
    }
    
    @IBAction func verifyTap() {
        guard let token = tokenField.text else {
            return
        }
        
        viewModel.verifyEmail(token: token)
    }

}

extension VerifyViewController: UITextFieldDelegate {
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
