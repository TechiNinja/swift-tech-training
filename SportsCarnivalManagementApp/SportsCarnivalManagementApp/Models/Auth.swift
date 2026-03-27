//
//  AUTH.swift
//  SportsCarnivalManagementApp
//
//  Created by Paras Gulvanshi on 26/03/26.
//


import Foundation

struct LoginPayload: Codable {
    let email: String
    let password: String
}

struct RegisterPayload: Codable {
    let fullName: String
    let email: String
    let password: String
}

struct AuthApiResponse: Codable {
    let id: Int
    let fullName: String
    let email: String
    let role: String
    let token: String
}

struct StoredUser: Codable {
    let id: Int
    let name: String
    let email: String
    let role: String
}
