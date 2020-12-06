//
//  UITextField+Extension.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/6/20.
//
import Foundation
import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setUpDesign(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.masksToBounds = true
        self.setLeftPaddingPoints(10)
        self.setRightPaddingPoints(10)
    }
}
