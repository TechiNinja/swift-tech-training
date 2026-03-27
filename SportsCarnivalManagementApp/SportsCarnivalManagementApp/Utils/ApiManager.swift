//
//  ApiManager.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case encodingFailed
    case decodingFailed
    case serverError(String)
}

final class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: String = "POST",
        body: U? = nil,
        token: String? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let urlString = APIConfig.baseURL + endpoint
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                completion(.failure(.encodingFailed))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(error.localizedDescription)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingFailed))
                    }
                }
            } else {
                let message = String(data: data, encoding: .utf8) ?? "Something went wrong."
                DispatchQueue.main.async {
                    completion(.failure(.serverError(message)))
                }
            }
            
        }.resume()
    }
}
