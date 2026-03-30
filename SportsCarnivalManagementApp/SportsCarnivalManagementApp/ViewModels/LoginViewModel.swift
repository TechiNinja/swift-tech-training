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
            delegate?.didValidateEmail(isValid: false, error: StringConstants.ErrorMessages.emailRequired)
            return
        }
        
        let isValid = ValidationHelper.isValidEmail(email)
        isEmailValid = isValid
        
        let errorMessage = isValid ? nil : StringConstants.ErrorMessages.invalidEmail
        delegate?.didValidateEmail(isValid: isValid, error: errorMessage)
    }
    
    func validatePassword() {
        if password.isEmpty {
            isPasswordValid = false
            delegate?.didValidatePassword(isValid: false, error: StringConstants.ErrorMessages.passwordRequired)
            return
        }
        
        let isValid = ValidationHelper.isValidPassword(password)
        isPasswordValid = isValid
        
        let errorMessage = isValid ? nil : StringConstants.ErrorMessages.invalidPassword
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.delegate?.didStopLoading()
            self?.delegate?.didSucceedLogin()
        }
    }
    
    private func validateFormForSubmission() -> Bool {
        validateEmail()
        validatePassword()
        
        if email.isEmpty {
            delegate?.didFailWithError(StringConstants.ErrorMessages.emailRequired)
            return false
        }
        
        if !isEmailValid {
            delegate?.didFailWithError(StringConstants.ErrorMessages.invalidEmail)
            return false
        }
        
        if password.isEmpty {
            delegate?.didFailWithError(StringConstants.ErrorMessages.passwordRequired)
            return false
        }
        
        if !isPasswordValid {
            delegate?.didFailWithError(StringConstants.ErrorMessages.invalidPassword)
            return false
        }
        
        return true
    }
}
