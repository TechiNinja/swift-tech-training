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
            delegate?.didValidateName(isValid: false, error: "Name is required")
            return
        }
        
        let isValid = ValidationHelper.isValidName(fullName)
        isNameValid = isValid
        
        let errorMessage = isValid ? nil : "Name must only contain letters and spaces"
        delegate?.didValidateName(isValid: isValid, error: errorMessage)
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
    
    func register() {
        guard validateFormForSubmission() else {
            return
        }
        
        delegate?.didStartLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.delegate?.didStopLoading()
            self.delegate?.didSucceedRegistration()
        }
    }
    
    private func validateFormForSubmission() -> Bool {
        validateName()
        validateEmail()
        validatePassword()
        
        if fullName.isEmpty {
            delegate?.didFailWithError("Full name is required")
            return false
        }
        
        if !isNameValid {
            delegate?.didFailWithError("Please enter a valid name")
            return false
        }
        
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
