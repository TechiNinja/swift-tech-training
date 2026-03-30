//
//  RegisterViewModel.swift
//  SportsCarnivalManagementApp
//
//  Created by Himani Jangid on 26/03/26.
//

import Foundation

protocol RegisterViewModelDelegate: AnyObject {
    func didStartLoading()
    func didStopLoading()
    func didFailWithError(_ error: String)
    func didSucceedRegistration()
    func didUpdateFormValidation(isValid: Bool)
    func didValidateName(isValid: Bool, error: String?)
    func didValidateEmail(isValid: Bool, error: String?)
    func didValidatePassword(isValid: Bool, error: String?)
}

class RegisterViewModel {
    weak var delegate: RegisterViewModelDelegate?
    
    var fullName: String = "" {
        didSet {
            validateName()
            updateFormValidation()
        }
    }
    
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
    
    private var isNameValid = false
    private var isEmailValid = false
    private var isPasswordValid = false
    
    var isFormValid: Bool {
        return isNameValid && isEmailValid && isPasswordValid && !fullName.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    func validateName() {
        if fullName.isEmpty {
            isNameValid = false
            delegate?.didValidateName(isValid: false, error: StringConstants.ErrorMessages.nameRequired)
            return
        }
        
        let isValid = ValidationHelper.isValidName(fullName)
        isNameValid = isValid
        
        let errorMessage = isValid ? nil : StringConstants.ErrorMessages.invalidName
        delegate?.didValidateName(isValid: isValid, error: errorMessage)
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
    
    func register() {
        guard validateFormForSubmission() else {
            return
        }
        
        delegate?.didStartLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.delegate?.didStopLoading()
            self?.delegate?.didSucceedRegistration()
        }
    }
    
    private func validateFormForSubmission() -> Bool {
        validateName()
        validateEmail()
        validatePassword()
        
        if fullName.isEmpty {
            delegate?.didFailWithError(StringConstants.ErrorMessages.nameRequired)
            return false
        }
        
        if !isNameValid {
            delegate?.didFailWithError(StringConstants.ErrorMessages.invalidName)
            return false
        }
        
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
