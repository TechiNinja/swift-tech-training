//
//  Api.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//


import Foundation

enum APIConfig {
    #if DEBUG
    static let host = "127.0.0.1"
    #else
    static let host = "your-production-host.com"
    #endif
    static let baseURL = "http://\(host):5000/api"
}

enum APIEndpoints {
    enum Auth {
        static let login = "/auth/login"
        static let register = "/auth/register"
    }
}
