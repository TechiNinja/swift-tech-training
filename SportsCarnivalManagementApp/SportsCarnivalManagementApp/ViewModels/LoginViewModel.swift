//
//  LoginViewModel.swift
//  
//
//  Created by Himani Jangid on 20/03/26.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didStartLoading()
    func didStopLoading()
    func didFailWithError(_ error: String)
    func didSucceedLogin()
    func didUpdateFormValidation(isValid: Bool)
    func didValidateEmail(isValid: Bool, error: String?)
    func didValidatePassword(isValid: Bool, error: String?)
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    var email: String = "" {
        didSet {
            validateEmail()
            updateFormValidation()
        }
    }
    
    var password: String = "" {
        didSet {
            validatePassword()
            updateFormValidation()
        }
    }
    
    private var isEmailValid = false
    private var isPasswordValid = false
    
    var isFormValid: Bool {
        return isEmailValid && isPasswordValid && !email.isEmpty && !password.isEmpty
    }
    
    func validateEmail() {
        if email.isEmpty {
            isEmailValid = false
            delegate?.didValidateEmail(isValid: false, error: "Email is required")
            return
        }
        
        let isValid = ValidationHelper.isValidEmail(email)
        isEmailValid = isValid
        
        let errorMessage = isValid ? nil : "Invalid email format"
        delegate?.didValidateEmail(isValid: isValid, error: errorMessage)
    }
    
    func validatePassword() {
        if password.isEmpty {
            isPasswordValid = false
            delegate?.didValidatePassword(isValid: false, error: "Password is required")
            return
        }
        
        let isValid = ValidationHelper.isValidPassword(password)
        isPasswordValid = isValid
        
        let errorMessage = isValid ? nil : "Password must include uppercase, lowercase, number, and special character"
        delegate?.didValidatePassword(isValid: isValid, error: errorMessage)
    }
    
    private func updateFormValidation() {
        delegate?.didUpdateFormValidation(isValid: isFormValid)
    }
    
    func login() {
        guard validateFormForSubmission() else {
            return
        }
        
        delegate?.didStartLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.delegate?.didStopLoading()
            self.delegate?.didSucceedLogin()
        }
    }
    
    private func validateFormForSubmission() -> Bool {
        validateEmail()
        validatePassword()
        
        if email.isEmpty {
            delegate?.didFailWithError("Email is required")
            return false
        }
        
        if !isEmailValid {
            delegate?.didFailWithError("Please enter a valid email")
            return false
        }
        
        if password.isEmpty {
            delegate?.didFailWithError("Password is required")
            return false
        }
        
        if !isPasswordValid {
            delegate?.didFailWithError("Password must include uppercase, lowercase, number, and special character")
            return false
        }
        
        return true
    }
}
