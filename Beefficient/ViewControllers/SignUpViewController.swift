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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }
    
    func setupBindings() {
        let viewModel = SignUpViewModel(
            input: (
                name: name.rx.text.orEmpty.asDriver(),
                email: email.rx.text.orEmpty.asDriver(),
                phoneNumber: phoneNumber.rx.text.orEmpty.asDriver(),
                password: password.rx.text.orEmpty.asDriver(),
                confirmPassword: confirmPassword.rx.text.orEmpty.asDriver(),
                signUpTap: signUp.rx.tap.asSignal()
            )
        )
        
        viewModel.signupEnabled
            .drive(onNext: { [weak self] (enabled) in
                self?.signUp.isEnabled = enabled
            }).disposed(by: rx.disposeBag)
        
        viewModel.signedIn
            .drive(onNext: { (signedIn) in
                if signedIn {
                    print("Signed up!!!")
                }
            }).disposed(by: rx.disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: rx.disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
}
