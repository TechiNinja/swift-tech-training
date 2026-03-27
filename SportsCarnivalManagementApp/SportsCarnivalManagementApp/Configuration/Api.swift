//
//  Api.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//


import Foundation

enum APIConfig {
    static let host = "localhost"
    static let baseURL = "http://\(host):5000/api"
}

enum APIEndpoints {
    enum Auth {
        static let login = "/auth/login"
        static let register = "/auth/register"
    }
}
