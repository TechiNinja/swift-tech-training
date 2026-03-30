//
//  UITextField+Extensions.swift
//
//
//  Created by Himani Jangid on 23/03/26.
//

import UIKit

extension UITextField {
    
    func setPadding(left: CGFloat, right: CGFloat) {
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
            
            self.leftView = leftView
            self.leftViewMode = .always
            self.rightView = rightView
            self.rightViewMode = .always
        }
    
    func setLeftIcon(systemName: String) {
            let iconView = UIImageView()
            iconView.image = UIImage(systemName: systemName)
            iconView.tintColor = .gray
            iconView.frame = CGRect(x: 10, y: 0, width: 22, height: 20)
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
            container.addSubview(iconView)
            
            self.leftView = container
            self.leftViewMode = .always
        }
    
    
    func addPasswordToggle(target: Any?, action: Selector) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        button.center = container.center
        container.addSubview(button)
        
        self.rightView = container
        self.rightViewMode = .always
    }
}
