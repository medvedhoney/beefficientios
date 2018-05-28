//
//  AuthViewController.swift
//  Beefficient
//
//  Created by Eugen on 02/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak fileprivate var login: UIButton!
    @IBOutlet weak fileprivate var signUp: UIButton!
    
    let loginSegue = "signIn"
    let signUpSegue = "signUp"
    
    let env = Environment.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        if env.user == nil {
            loginWithToken()
        }
    }
    
    @IBAction func loginTap() {
        performSegue(withIdentifier: loginSegue, sender: nil)
    }
    
    @IBAction func registerTap() {
        performSegue(withIdentifier: signUpSegue, sender: nil)
    }
    
    func loginWithToken() {
        guard let id = env.getUserId() else {
            return
        }
        
        env.networkManager.getUser(id: id) { [weak self] (user, _) in
            guard let user = user else {
                return
            }
            
            self?.env.saveCurrentUser(currentUser: user)
            
            DispatchQueue.main.async {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                UIApplication.shared.delegate?.window!?.rootViewController = controller
            }
        }
    }

}
