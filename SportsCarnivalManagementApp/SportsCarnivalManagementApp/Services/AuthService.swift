//
//  AuthService.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//

import Foundation

final class AuthService {
    
    private let network: NetworkService
    
    init(network: NetworkService = ApiManager.shared) {
        self.network = network
    }
    
    func login(payload: LoginPayload) async throws -> AuthApiResponse {
        return try await network.request(
            endpoint: APIEndpoints.Auth.login,
            method: .post,
            body: payload
        )
    }
    
    func register(payload: RegisterPayload) async throws -> AuthApiResponse {
        return try await network.request(
            endpoint: APIEndpoints.Auth.register,
            method: .post,
            body: payload
        )
    }
}
