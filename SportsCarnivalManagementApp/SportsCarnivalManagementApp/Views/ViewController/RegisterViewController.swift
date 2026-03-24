//
//  RegisterViewController.swift
//  SportsCarnivalManagementApp
//
//  Created by Himani Jangid on 24/03/26.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderColor = UIColor(named: "InputText") ?? .gray
        
        registerContainerView.layer.cornerRadius = 10
        registerContainerView.clipsToBounds = true
        registerContainerView.layer.borderColor = UIColor(named: "Border")?.cgColor
        registerContainerView.layer.borderWidth = 1
        
        nameTextField.layer.cornerRadius = 5
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your full name",
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
        
        registerEmailTextField.layer.cornerRadius = 5
        registerEmailTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
        
        registerPasswordTextField.layer.cornerRadius = 5
        registerPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
        
    }
    
}
