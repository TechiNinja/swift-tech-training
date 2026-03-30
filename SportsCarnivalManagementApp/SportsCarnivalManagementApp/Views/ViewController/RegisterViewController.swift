//
//  RegisterViewController.swift
//  SportsCarnivalManagementApp
//
//  Created by Himani Jangid on 24/03/26.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerContainerView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var trophyIcon: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var nameErrorText: UILabel!
    @IBOutlet weak var emailErrorText: UILabel!
    @IBOutlet weak var passwordErrorText: UILabel!
    
    private var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
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
        registerContainerView.layer.cornerRadius = 10
        registerContainerView.clipsToBounds = true
        registerContainerView.layer.borderColor = UIColor(named: "Border")?.cgColor
        registerContainerView.layer.borderWidth = 1
    }
    
    private func setupTextFields() {
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        
        nameTextField.delegate = self
        registerEmailTextField.delegate = self
        registerPasswordTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        registerEmailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        registerPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)

    }
    
    private func setupNameTextField() {
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor(named: "Border")?.cgColor
        nameTextField.setPadding(left: 12, right: 12)
        nameTextField.setLeftIcon(systemName: "person")
        
        let placeholderColor = UIColor(named: "InputText") ?? .gray
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: StringConstants.placeholders.name,
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
    }
    
    private func setupEmailTextField() {
        registerEmailTextField.layer.cornerRadius = 5
        registerEmailTextField.layer.borderWidth = 1
        registerEmailTextField.layer.borderColor = UIColor(named: "Border")?.cgColor
        registerEmailTextField.setPadding(left: 12, right: 12)
        registerEmailTextField.setLeftIcon(systemName: "envelope")
        registerEmailTextField.keyboardType = .emailAddress
        registerEmailTextField.autocapitalizationType = .none
        registerEmailTextField.autocorrectionType = .no
        
        let placeholderColor = UIColor(named: "InputText") ?? .gray
        registerEmailTextField.attributedPlaceholder = NSAttributedString(
            string: StringConstants.placeholders.email,
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
    }
    
    private func setupPasswordTextField() {
        registerPasswordTextField.layer.cornerRadius = 5
        registerPasswordTextField.layer.borderWidth = 1
        registerPasswordTextField.layer.borderColor = UIColor(named: "Border")?.cgColor
        registerPasswordTextField.setPadding(left: 12, right: 12)
        registerPasswordTextField.setLeftIcon(systemName: "lock")
        registerPasswordTextField.isSecureTextEntry = true
        registerPasswordTextField.addPasswordToggle(target: self, action: #selector(togglePassword))
        
        let placeholderColor = UIColor(named: "InputText") ?? .gray
        registerPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: StringConstants.placeholders.password,
            attributes: [
                .foregroundColor: placeholderColor
            ]
        )
    }
    
    private func setupButton() {
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.5
    }
    
    private func setupTrophyIcon() {
        trophyIcon.layer.cornerRadius = 5
        trophyIcon.clipsToBounds = true
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setupErrorLabels() {
        nameErrorText.isHidden = true
        emailErrorText.isHidden = true
        passwordErrorText.isHidden = true
        
        nameErrorText.textColor = UIColor(named: "Error")
        emailErrorText.textColor = UIColor(named: "Error")
        passwordErrorText.textColor = UIColor(named: "Error")
    }
    
    @IBAction func onClickSignUpButton(_ sender: UIButton) {
        viewModel.register()
    }
    @IBAction func onClickSignInButton(_ sender: UIButton) {
        navigateToLogin()
    }
    
    @objc private func nameTextFieldDidChange() {
        viewModel.fullName = nameTextField.text ?? ""
        clearFieldErrors(textField: nameTextField)
    }
    
    @objc private func emailTextFieldDidChange() {
        viewModel.email = registerEmailTextField.text ?? ""
        clearFieldErrors(textField: registerEmailTextField)
    }
    
    @objc private func passwordTextFieldDidChange() {
        viewModel.password = registerPasswordTextField.text ?? ""
        clearFieldErrors(textField: registerPasswordTextField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.validateName()
        } else if textField == registerEmailTextField {
            viewModel.validateEmail()
        } else if textField == registerPasswordTextField {
            viewModel.validatePassword()
        }
    }
    
    @objc func togglePassword(_ sender: UIButton) {
        registerPasswordTextField.isSecureTextEntry.toggle()
        sender.isSelected = !registerPasswordTextField.isSecureTextEntry
    }
    
    private func updateButtonState(isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
        signUpButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    private func showLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
            signUpButton.isEnabled = false
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    private func showFieldError(textField: UITextField) {
        textField.layer.borderColor = UIColor(named: "Error")?.cgColor
    }
    
    private func clearFieldErrors(textField: UITextField) {
        textField.layer.borderColor = UIColor(named: "Border")?.cgColor
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showSuccessAndNavigateToLogin() {
        let alert = UIAlertController(title: "Success", message: StringConstants.sucessMessages.accountCreated, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func didStartLoading() {
        showLoadingState(true)
    }
    
    func didStopLoading() {
        showLoadingState(false)
    }
    
    func didFailWithError(_ error: String) {
        showAlert(error)
    }
    
    func didSucceedRegistration() {
        showSuccessAndNavigateToLogin()
    }
    
    func didUpdateFormValidation(isValid: Bool) {
        updateButtonState(isEnabled: isValid)
    }
    
    func didValidateName(isValid: Bool, error: String?) {
        if let error = error {
            nameErrorText.text = error
            nameErrorText.isHidden = false
            showFieldError(textField: nameTextField)
        } else {
            nameErrorText.isHidden = true
            clearFieldErrors(textField: nameTextField)
        }
    }
    
    func didValidateEmail(isValid: Bool, error: String?) {
        if let error = error {
            emailErrorText.text = error
            emailErrorText.isHidden = false
            showFieldError(textField: registerEmailTextField)
        } else {
            emailErrorText.isHidden = true
            clearFieldErrors(textField: registerEmailTextField)
        }
    }
    
    func didValidatePassword(isValid: Bool, error: String?) {
        if let error = error {
            passwordErrorText.text = error
            passwordErrorText.isHidden = false
            showFieldError(textField: registerPasswordTextField)
        } else {
            passwordErrorText.isHidden = true
            clearFieldErrors(textField: registerPasswordTextField)
        }
    }
}
