//
//  APIManager.swift
//  Beefficient
//
//  Created by Eugen on 27/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import RxSwift

public class APIManager: NSObject {
    static let sharedAPI = APIManager()
    
    public func singUp(name: String, email: String, password: String, phone: String) -> Single<Bool> {
        BeefficientProvider.rx.request(BeefficientAPI.signUp(name: name, email: email, password: password, phone: phone))
            .map(<#T##type: Decodable.Protocol##Decodable.Protocol#>)
    }
}
