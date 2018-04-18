//
//  AlertNotification.swift
//  Beefficient
//
//  Created by Eugen on 18/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation
import UIKit

typealias AlertButton = (title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?)

protocol AlertNotification {
    func alert(title: String?, message: String?, buttons: [AlertButton], completion: (() -> Void)?) -> UIViewController
}

extension AlertNotification {
    func alert(title: String?, message: String?, buttons: [AlertButton], completion: (() -> Void)?) -> UIViewController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for button in buttons {
            let action = UIAlertAction(title: button.title, style: button.style, handler: button.handler)
            controller.addAction(action)
        }
        
        return controller
    }
}
