//
//  ApiManager.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case encodingFailed
    case decodingFailed
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return StringConstants.ErrorMessages.invalidURL
        case .invalidResponse:
            return StringConstants.ErrorMessages.invalidResponse
        case .noData:
            return StringConstants.ErrorMessages.noData
        case .encodingFailed:
            return StringConstants.ErrorMessages.encodingFailed
        case .decodingFailed:
            return StringConstants.ErrorMessages.decodingFailed
        case .serverError(let message):
            return message
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkService {
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: U?
    ) async throws -> T
}

final class ApiManager: NetworkService {
    
    static let shared = ApiManager()
    private init() {}
    
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        body: U? = nil
    ) async throws -> T {
        
        let urlString = APIConfig.baseURL + endpoint
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthStorage.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encodingFailed
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
            
        default:
            let message = String(data: data, encoding: .utf8)
                ?? StringConstants.ErrorMessages.somethingWrong
            throw NetworkError.serverError(message)
        }
    }
}
