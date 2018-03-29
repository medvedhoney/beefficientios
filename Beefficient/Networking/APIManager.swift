//
//  APIManager.swift
//  Beefficient
//
//  Created by Eugen on 27/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import RxSwift

public class APIManager: APIProtocol {
    
    static let sharedAPI = APIManager()
    
    func singUp(name: String, email: String, password: String, phone: String) -> Single<Authorization> {
        return BeefficientProvider.rx.request(BeefficientAPI.signUp(name: name, email: email, password: password, phone: phone))
            .map(Authorization.self)
            .observeOn(MainScheduler.instance)
            .flatMap({ auth -> Single<Authorization> in
                return Single.just(auth)
            })
    }
}
