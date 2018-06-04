//
//  HivesHeaderTableViewCell.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 02/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

protocol HiveActions: NSObjectProtocol {
    func createHive()
    func joinHive()
    func useInvite()
}

class HivesHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak fileprivate var createView: UIView!
    @IBOutlet weak fileprivate var joinView: UIView!
    @IBOutlet weak fileprivate var inviteView: UIView!
    
    weak var delegate: HiveActions?
    
    func configure(){
        createView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createHive)))
        joinView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(joinHive)))
        inviteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(useInvite)))
    }
    
    @objc func createHive() {
        delegate?.createHive()
    }
    
    @objc func joinHive() {
        delegate?.joinHive()
    }
    
    @objc func useInvite() {
        delegate?.useInvite()
    }
    
}
