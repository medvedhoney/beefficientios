//
//  LoginViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class LoginViewController: UIViewController {
    @IBOutlet weak fileprivate var loginField: UITextField!
    @IBOutlet weak fileprivate var passwordField: UITextField!
    @IBOutlet weak fileprivate var login: UIButton!
    @IBOutlet weak fileprivate var close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }
    
    func setupBindings() {
        close.rx.tap.subscribe {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }.disposed(by: rx.disposeBag)
    }

}
