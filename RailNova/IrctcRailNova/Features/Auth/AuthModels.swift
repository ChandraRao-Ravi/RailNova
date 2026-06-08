//
//  AuthModels.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let user: User
}

struct MeResponse: Decodable {
    let user: User
}

struct User: Decodable {
    let id: String
    let email: String?
    let fullName: String?
    let phone: String?
    let dob: String?
    let gender: String?
    let nationality: String?
    let city: String?
    let state: String?
    let authProvider: String?
    let isEmailVerified: Bool
    let isPhoneVerified: Bool
    let isProfileComplete: Bool
    let profileCompletionScore: Int
}

struct UpdateProfileRequest: Encodable {
    let fullName: String?
    let phone: String?
    let dob: String?
    let gender: String?
    let nationality: String?
    let city: String?
    let state: String?
}

struct GoogleAuthRequest: Encodable {
    let idToken: String
}

struct AppleAuthRequest: Encodable {
    let identityToken: String
    let authorizationCode: String?
}
