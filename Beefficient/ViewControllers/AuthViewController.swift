//
//  AuthViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class AuthViewController: UIViewController {
    @IBOutlet weak fileprivate var login: UIButton!
    @IBOutlet weak fileprivate var signUp: UIButton!
    
    let loginSegue = "signIn"
    let signUpSegue = "signUp"

    override func viewDidLoad() {
        super.viewDidLoad()

        login.rx.tap.subscribe { (_) in
            self.performSegue(withIdentifier: self.loginSegue, sender: nil)
        }.disposed(by: rx.disposeBag)
        
        signUp.rx.tap.subscribe { (_) in
            self.performSegue(withIdentifier: self.signUpSegue, sender: nil)
        }.disposed(by: rx.disposeBag)
    }

}
