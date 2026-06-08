//
//  AuthManager.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var currentUser: User?
    @Published var errorMessage: String?

    private(set) var accessToken: String?

    init() {
        accessToken = KeychainService.shared.getToken()
    }

    func restoreSession() async {
        guard let token = KeychainService.shared.getToken(), !token.isEmpty else {
            isAuthenticated = false
            currentUser = nil
            accessToken = nil
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await APIClient.shared.getMe()
            accessToken = token
            currentUser = response.user
            isAuthenticated = true
        } catch {
            KeychainService.shared.deleteToken()
            accessToken = nil
            currentUser = nil
            isAuthenticated = false
            errorMessage = nil
        }

        isLoading = false
    }

    func signup(fullName: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await APIClient.shared.signup(
                fullName: fullName,
                email: email,
                password: password
            )
            applyAuth(response)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await APIClient.shared.login(
                email: email,
                password: password
            )
            applyAuth(response)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loginWithGoogle() async {
        isLoading = true
        errorMessage = nil

        do {
            let firebaseIdToken = try await GoogleSignInService.shared.signInAndGetFirebaseToken()
            let response = try await APIClient.shared.loginWithSocial(
                provider: "google",
                firebaseIdToken: firebaseIdToken
            )
            applyAuth(response)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loginWithApple() async {
        isLoading = true
        errorMessage = nil

        do {
            let firebaseIdToken = try await AppleSignInService.shared.signInAndGetFirebaseToken()
            let response = try await APIClient.shared.loginWithSocial(
                provider: "apple",
                firebaseIdToken: firebaseIdToken
            )
            applyAuth(response)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refreshMe() async {
        guard accessToken != nil else { return }

        do {
            let response = try await APIClient.shared.getMe()
            currentUser = response.user
        } catch {
            logout()
        }
    }

    func updateProfile(payload: UpdateProfileRequest) async {
        guard accessToken != nil else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await APIClient.shared.updateProfile(profile: payload)
            currentUser = response.user
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func logout() {
        KeychainService.shared.deleteToken()
        accessToken = nil
        currentUser = nil
        isAuthenticated = false
        errorMessage = nil
    }

    private func applyAuth(_ response: AuthResponse) {
        _ = KeychainService.shared.saveToken(response.accessToken)
        accessToken = response.accessToken
        currentUser = response.user
        isAuthenticated = true
        errorMessage = nil
    }
}
