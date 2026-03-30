//
//  Untitled.swift
//  SportsCarnivalManagementApp
//
//  Created by Himani Jangid on 30/03/26.
//

import Foundation

enum StringConstants {
    enum ErrorMessages {
        static let emailRequired = "Email is required"
        static let invalidEmail = "Invalid email format"
        static let passwordRequired = "Password is required"
        static let invalidPassword = "Password must include uppercase, lowercase, number, and special character"
        static let nameRequired = "Name is required"
        static let invalidName = "Name must only contain letters and spaces"
    }
    
    enum sucessMessages {
        static let loginSuccess = "Login Successful!"
        static let accountCreated = "Account created successfully!"
    }
    
    enum placeholders {
        static let email = "Enter your email"
        static let name = "Enter your full name"
        static let password = "Enter your password"
    }
}
