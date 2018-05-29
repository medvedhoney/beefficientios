//
//  UIView+Ext.swift
//  Beefficient
//
//  Created by Eugeniu Draguteanu on 29/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
