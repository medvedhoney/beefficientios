//
//  MemberTableViewCell.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 06/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

struct MemberData {
    let userId: String
    let ownerName: String
    let completed: [String]
    let owner: Bool
    let ownUser: Bool
}

protocol MemberProtocol: NSObjectProtocol {
    func deleteUser(userId: String)
    func callUser(userId: String)
}

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak fileprivate var owner: UILabel!
    @IBOutlet weak fileprivate var completed: UILabel!
    @IBOutlet weak fileprivate var closeButton: UIButton!
    
    var userId: String!
    weak var delegate: MemberProtocol?
    
    func populate(with member: MemberData) {
        userId = member.userId
        owner.text = member.ownerName
        completed.text = member.completed.joined(separator: ", ")
        
        closeButton.isHidden = !member.owner || member.ownUser
    }
    
    @IBAction func call() {
        delegate?.callUser(userId: userId)
    }
    
    @IBAction func removeMember() {
        delegate?.deleteUser(userId: userId)
    }
    
}
