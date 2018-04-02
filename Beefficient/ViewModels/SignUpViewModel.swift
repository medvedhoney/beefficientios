//
//  SignUpViewModel.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import RxSwift
import RxCocoa

class SignUpViewModel {
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    let signupEnabled: Driver<Bool>
    let signedIn: Driver<Bool>
    
    init(
        input: (
            name: Driver<String>,
            email: Driver<String>,
            phoneNumber: Driver<String>,
            password: Driver<String>,
            confirmPassword: Driver<String>,
            signUpTap: Signal<Void>
        )
    ) {
        let validation = Validation.shared
        let API = APIManager.sharedAPI
        
        validatedPassword = input.password
            .map { password in
                return validation.validatePassword(password)
            }
        
        validatedPasswordRepeated = Driver.combineLatest(input.password, input.confirmPassword, resultSelector: validation.validateRepeatedPassword)
        
        signupEnabled = Driver.combineLatest(validatedPassword, validatedPasswordRepeated) {
            password, confirmPassword in
            password.isValid && confirmPassword.isValid
        }.distinctUntilChanged()
        
        let credentials = Driver.combineLatest(input.name, input.email, input.phoneNumber, input.password) { (name: $0, email: $1, phone: $2, password: $3) }
        
        signedIn = input.signUpTap.withLatestFrom(credentials)
            .flatMapLatest { credentials in
                return API.singUp(name: credentials.name, email: credentials.email, password: credentials.password, phone: credentials.phone).asDriver(onErrorJustReturn: Authorization())
            }
            .flatMapLatest { auth -> Driver<Bool> in
                let success = auth.result == true
                return Observable.just(success).asDriver(onErrorJustReturn: false)
            }
    }
}
