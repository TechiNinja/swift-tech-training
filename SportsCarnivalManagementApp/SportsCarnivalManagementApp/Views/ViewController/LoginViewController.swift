//
//  ViewController.swift
//  SportsCarnivalManagementApp
//
//  Created by Himani Jangid on 20/03/26.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderColor = UIColor(named: "InputText") ?? .gray
        
        loginContainerView.layer.cornerRadius = 10
        loginContainerView.clipsToBounds = true
        loginContainerView.layer.borderWidth = 1
        loginContainerView.layer.borderColor = UIColor(named: "Border")?.cgColor
        
        emailTextField.layer.cornerRadius = 5
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
    }

    
    @IBAction func onClickSignInButton(_ sender: UIButton) {
        print("Button tapped")
    }
    
}

