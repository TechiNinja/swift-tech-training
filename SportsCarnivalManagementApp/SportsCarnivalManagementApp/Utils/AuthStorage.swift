//
//  AuthStorage.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//


import Foundation

enum AuthStorageKeys {
    static let token = "auth_token"
    static let user = "stored_user"
}

final class AuthStorage {
    
    static let shared = AuthStorage()
    private init() {}
    
    func saveToken(_ token: String) -> Bool {
        KeychainManager.shared.save(key: AuthStorageKeys.token, value: token)
    }
    
    func getToken() -> String? {
        KeychainManager.shared.get(key: AuthStorageKeys.token)
    }
    
    func deleteToken() -> Bool {
        KeychainManager.shared.delete(key: AuthStorageKeys.token)
    }
    
    func saveUser(_ user: StoredUser) -> Bool {
        guard let data = try? JSONEncoder().encode(user) else { return false }
        UserDefaults.standard.set(data, forKey: AuthStorageKeys.user)
        return true
    }
    
    func getUser() -> StoredUser? {
        guard let data = UserDefaults.standard.data(forKey: AuthStorageKeys.user) else { return nil }
        return try? JSONDecoder().decode(StoredUser.self, from: data)
    }
    
    func deleteUser() -> Bool {
        UserDefaults.standard.removeObject(forKey: AuthStorageKeys.user)
        return UserDefaults.standard.data(forKey: AuthStorageKeys.user) == nil
    }
    
    func clearSession() {
        let isTokenDeleted = deleteToken()
        let isUserDeleted = deleteUser()
        
        if !isTokenDeleted {
            print(StringConstants.ErrorMessages.tokenDeleteFailed)
        }
        
        if !isUserDeleted {
            print(StringConstants.ErrorMessages.userDeleteFailed)
        }
    }
}
