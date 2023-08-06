//
//  Extensions.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 6.08.2023.
//

import UIKit


extension UIColor {
    
    static func rgbConverter(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        let color = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        return color
        
    }
}


extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, topPadding: CGFloat, leadingPadding: CGFloat, trailingPadding: CGFloat, bottomPadding: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: leadingPadding).isActive = true
        }

        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: trailingPadding).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: bottomPadding).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
