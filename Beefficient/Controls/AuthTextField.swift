//
//  AuthTextField.swift
//  Beefficient
//
//  Created by Eugen on 18/04/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

@IBDesignable
class AuthTextField: UITextField {
    private let color = UIColor(rgb: 0x8FD2EF)
    private let highlightedColor = UIColor.white
    private let borderName = "border"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForInterfaceBuilder() {
        attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(rgb: 0x8FD2EF)])
    }
    
    func setupStyle() {
        textColor = color
        setPlaceHolderColor(color: color)
        addButtomBorder()
    }
    
    func setNormalState() {
        textColor = color
        setPlaceHolderColor(color: color)
        setBorderColor(color: color)
        setBorderWidth(width: 1)
    }
    
    func setHighlightedState() {
        textColor = highlightedColor
        setPlaceHolderColor(color: highlightedColor)
        setBorderColor(color: color)
        setBorderWidth(width: 1)
    }
    
    func addButtomBorder() {
        let border = CALayer()
        let borderWidth: CGFloat = 1
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
        border.name = "border"
        
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    func setPlaceHolderColor(color: UIColor){
        attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func setBorderColor(color: UIColor) {
        guard let border = layer.sublayers?.first(where: { $0.name == borderName }) else {
            return
        }
        
        border.backgroundColor = color.cgColor
    }
    
    func setBorderWidth(width: CGFloat) {
        guard let border = layer.sublayers?.first(where: { $0.name == borderName }) else {
            return
        }
        
        border.frame = CGRect(x: 0, y: frame.height - width, width: frame.width, height: width)
    }

}
