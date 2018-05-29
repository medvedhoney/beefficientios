//
//  ChatMessageTableViewCell.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 29/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

enum MessageType {
    case reply, own
    
    var color: UIColor {
        switch self {
        case .reply:
            return UIColor(rgb: 0xf1f1f1)
        case .own:
            return UIColor(rgb: 0x104160)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .reply:
            return UIColor(rgb: 0x000000)
        case .own:
            return UIColor(rgb: 0xffffff)
        }
    }
}

struct ChatMessage {
    let owner: String
    let message: String
    let time: String
    let type: MessageType
}

class ChatMessageTableViewCell: UITableViewCell {
    @IBOutlet weak fileprivate var messageView: UIView!
    @IBOutlet weak fileprivate var authorView: UIView!
    @IBOutlet weak fileprivate var messageLabel: UILabel!
    @IBOutlet weak fileprivate var authorLabel: UILabel!
    @IBOutlet weak fileprivate var leftMargin: NSLayoutConstraint!
    @IBOutlet weak fileprivate var rightMargin: NSLayoutConstraint!
    
    let bigMargin: CGFloat = 32
    let littleMargin: CGFloat = 8
    let cornerRadius: CGFloat = 10
    let timeColor = UIColor(rgb: 0x4B748B)
    
    var message: ChatMessage?
    
    func populate(with message: ChatMessage) {
        self.message = message
        
        authorLabel.text = message.owner
        messageLabel.attributedText = getAttributedMessage(type: message.type, time: message.time, message: message.message)
        
        setBackground(color: message.type.color)
        setMargins(type: message.type)
    }
    
    func getAttributedMessage(type: MessageType, time: String, message: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()
        
        mutableString.append(NSAttributedString(string: message, attributes: [.foregroundColor : type.textColor]))
        mutableString.append(NSAttributedString(string: " \(time)", attributes: [.foregroundColor : timeColor]))
        
        return mutableString
    }
    
    func setBackground(color: UIColor) {
        messageView.backgroundColor = color
        authorView.backgroundColor = color
    }
    
    func setCorners(type: MessageType) {
        var leftCorners: UIRectCorner = [.topLeft]
        var rightCorners: UIRectCorner = [.topRight]
        
        if type == .own {
            leftCorners.update(with: .bottomLeft)
        } else {
            rightCorners.update(with: .bottomRight)
        }
        
        messageView.roundCorners(leftCorners, radius: cornerRadius)
        authorView.roundCorners(rightCorners, radius: cornerRadius)
    }
    
    func setMargins(type: MessageType) {
        if type == .own {
            leftMargin.constant = bigMargin
            rightMargin.constant = littleMargin
        } else {
            leftMargin.constant = littleMargin
            rightMargin.constant = bigMargin
        }
    }

}
