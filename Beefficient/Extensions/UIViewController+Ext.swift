//
//  UIViewController+Ext.swift
//  Beefficient
//
//  Created by Eugen on 18/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

extension UIViewController: AlertNotification {
    var okButton: AlertButton {
        get {
            return (title: "Ok", style: .cancel, nil)
        }
    }
    
    func showAlert(title: String?, message: String?, buttons: [AlertButton], completion: (() -> Void)?) {
        let controller = alert(title: title, message: message, buttons: buttons, completion: completion)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func showError(error: String?) {
        showAlert(title: "Error", message: error, buttons: [okButton], completion: nil)
    }
    
    func showSuccess() {
        showAlert(title: "Success", message: nil, buttons: [okButton], completion: nil)
    }
}
