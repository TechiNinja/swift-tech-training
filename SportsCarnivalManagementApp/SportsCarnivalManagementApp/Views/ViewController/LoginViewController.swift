//
//  LoginViewController.swift
//  SportsCarnivalManagementApp
//
//  Created by Himani Jangid on 20/03/26.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var trophyIcon: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailErrorText: UILabel!
    @IBOutlet weak var passwordErrorText: UILabel!
    
    private var viewModel = LoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViewModel()
        setupUI()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupUI() {
        setupContainerView()
        setupTextFields()
        setupButton()
        setupTrophyIcon()
        setupLoadingIndicator()
        setupErrorLabels()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupContainerView() {
        loginContainerView.layer.cornerRadius = 10
        loginContainerView.clipsToBounds = true
        loginContainerView.layer.borderWidth = 1
        loginContainerView.layer.borderColor = UIColor(named: "Border")?.cgColor
    }
    
    private func setupTextFields() {
        setupEmailTextField()
        setupPasswordTextField()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
    }
    
    private func setupEmailTextField() {
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(named: "Border")?.cgColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.setPadding(left: 12, right: 12)
        emailTextField.setLeftIcon(systemName: "envelope")
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        
        let placeholderColor = UIColor(named: "InputText") ?? .gray
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: StringConstants.placeholders.email,
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
    }
    
    private func setupPasswordTextField() {
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor(named: "Border")?.cgColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.isSecureTextEntry = true
        passwordTextField.setPadding(left: 12, right: 12)
        passwordTextField.setLeftIcon(systemName: "lock")
        passwordTextField.addPasswordToggle(target: self, action: #selector(togglePassword))
        
        let placeholderColor = UIColor(named: "InputText") ?? .gray
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: StringConstants.placeholders.password,
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
    }
    
    private func setupButton() {
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
    }
    
    private func setupTrophyIcon() {
        trophyIcon.layer.cornerRadius = 5
        trophyIcon.clipsToBounds = true
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.isHidden = true
    }
    
    private func setupErrorLabels() {
        emailErrorText.isHidden = true
        passwordErrorText.isHidden = true
        
        emailErrorText.textColor = UIColor(named: "Error")
        passwordErrorText.textColor = UIColor(named: "Error")
    }
    
    @IBAction func onClickSignInButton(_ sender: UIButton) {
        clearAllFieldErrors()
        viewModel.login()
    }
    
    @IBAction func onClickSignUpButton(_ sender: UIButton) {
        navigateToRegister()
    }
    
    @objc private func emailTextFieldDidChange() {
        viewModel.email = emailTextField.text ?? ""
        clearFieldErrors(textField: emailTextField)
    }
    
    @objc private func passwordTextFieldDidChange() {
        viewModel.password = passwordTextField.text ?? ""
        clearFieldErrors(textField: passwordTextField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            viewModel.validateEmail()
        } else if textField == passwordTextField {
            viewModel.validatePassword()
        }
    }
    
    @objc func togglePassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected = !passwordTextField.isSecureTextEntry
    }
    
    private func updateButtonState(isEnabled: Bool) {
        signInButton.isEnabled = isEnabled
        signInButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    private func showLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
            signInButton.isEnabled = false
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    private func showFieldError(textField: UITextField, message: String) {
        textField.layer.borderColor = UIColor(named: "Error")?.cgColor
    }
    
    private func clearFieldErrors(textField: UITextField) {
        textField.layer.borderColor = UIColor(named: "Border")?.cgColor
    }
    
    private func clearAllFieldErrors() {
        clearFieldErrors(textField: emailTextField)
        clearFieldErrors(textField: passwordTextField)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToRegister() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            navigationController?.pushViewController(registerViewController, animated: true)
        }
    }
    
    private func navigateToMainApp() {
        let alert = UIAlertController(title: "Success", message: StringConstants.sucessMessages.loginSuccess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func didStartLoading() {
        showLoadingState(true)
    }
    
    func didStopLoading() {
        showLoadingState(false)
    }
        
    func didFailWithError(_ error: String) {
        showAlert(error)
    }
        
    func didSucceedLogin() {
        navigateToMainApp()
    }
        
    func didUpdateFormValidation(isValid: Bool) {
        updateButtonState(isEnabled: isValid)
    }
        
    func didValidateEmail(isValid: Bool, error: String?) {
        if let error = error {
            emailErrorText.text = error
            emailErrorText.isHidden = false
            showFieldError(textField: emailTextField, message: error)
        } else {
            emailErrorText.isHidden = true
            clearFieldErrors(textField: emailTextField)
        }
    }
        
    func didValidatePassword(isValid: Bool, error: String?) {
        if let error = error {
            passwordErrorText.text = error
            passwordErrorText.isHidden = false
            showFieldError(textField: passwordTextField, message: error)
        } else {
            passwordErrorText.isHidden = true
            clearFieldErrors(textField: passwordTextField)
        }
    }
}
