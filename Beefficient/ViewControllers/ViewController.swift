//
//  ViewController.swift
//  Beefficient
//
//  Created by Eugen on 27/03/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

public protocol ViewControllerInputs {
    var loginTaps: PublishSubject<Void> { get }
    var email:PublishSubject<String?> { get }
    var password:PublishSubject<String?> { get }
    var name:PublishSubject<String?> { get }
    var phone:PublishSubject<String?> { get }
}

public protocol ViewControllerOutputs {
    var signedUp: PublishSubject<Void> { get }
}

public protocol ViewControllerModelType {
    var inputs: ViewControllerInputs { get }
    var outputs: ViewControllerOutputs { get }
}

public class ViewControllerViewModel: ViewControllerModelType, ViewControllerInputs, ViewControllerOutputs {
    public var inputs: ViewControllerInputs { return self}
    public var outputs: ViewControllerOutputs { return self}
    public var loginTaps: PublishSubject<Void>
    public var email:PublishSubject<String?>
    public var password:PublishSubject<String?>
    public var name:PublishSubject<String?>
    public var phone:PublishSubject<String?>
    public var signedUp: PublishSubject<Void>
    
    init() {
        loginTaps = PublishSubject<Void>()
        signedUp = PublishSubject<Void>()
    }
}

class ViewController: UIViewController {
    private let viewModel = ViewControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: self.view.frame.size.width - 60, y: 60, width: 50, height: 50)
        button.setTitle("Buton", for: .normal)
        button.rx.tap
            .bind(to: viewModel.inputs.loginTaps)
            .disposed(by: rx.disposeBag)
        
        view.addSubview(button)
    }
    
    func buttonTapped() {
        
    }

}

