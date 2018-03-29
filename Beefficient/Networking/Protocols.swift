//
//  Protocols.swift
//  Beefficient
//
//  Created by Eugen on 29/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//
import RxSwift

protocol APIProtocol {
    func singUp(name: String, email: String, password: String, phone: String) -> Single<Authorization>
}
