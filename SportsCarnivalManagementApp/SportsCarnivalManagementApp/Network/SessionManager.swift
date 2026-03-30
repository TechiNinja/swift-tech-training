//
//  SessionManager.swift
//
//
//  Created by Paras Gulvanshi on 26/03/26.
//


import Foundation

final class SessionManager {
    
    static let shared = SessionManager()
    
    private init() {}
    
    func isLoggedIn() -> Bool {
        let token = AuthStorage.shared.getToken()
        let user = AuthStorage.shared.getUser()
        
        return token != nil && user != nil
    }
    
    func getCurrentUser() -> StoredUser? {
        return AuthStorage.shared.getUser()
    }
    
    func getToken() -> String? {
        return AuthStorage.shared.getToken()
    }
    
    func saveSession(from response: AuthApiResponse) -> Bool {
        let user = StoredUser(
            id: response.id,
            name: response.fullName,
            email: response.email,
            role: response.role
        )
        
        let isTokenSaved = AuthStorage.shared.saveToken(response.token)
        let isUserSaved = AuthStorage.shared.saveUser(user)
        
        return isTokenSaved && isUserSaved
    }
    
    func logout() {
        AuthStorage.shared.clearSession()
    }
}
