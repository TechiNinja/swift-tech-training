//
//  AuthService.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//

import Foundation

final class AuthService {
    
    static let shared = AuthService()
    
    private init() {}
    
    func login(
        payload: LoginPayload,
        completion: @escaping (Result<AuthApiResponse, NetworkError>) -> Void
    ) {
        ApiManager.shared.request(
            endpoint: APIEndpoints.Auth.login,
            body: payload,
            completion: completion
        )
    }
    
    func register(
        payload: RegisterPayload,
        completion: @escaping (Result<AuthApiResponse, NetworkError>) -> Void
    ) {
        ApiManager.shared.request(
            endpoint: APIEndpoints.Auth.register,
            body: payload,
            completion: completion
        )
    }
}
