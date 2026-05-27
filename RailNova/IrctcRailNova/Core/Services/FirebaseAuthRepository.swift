//
//  FirebaseAuthRepository.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 26/05/26.
//

import Combine
import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

// MARK: - AuthRepository Protocol

protocol AuthRepository {
    var isLoggedIn: Bool { get }
    var currentUserId: String? { get }

    func signInWithGoogle(presenting viewController: UIViewController) async throws
    func signInWithApple(credential: AuthCredential) async throws
    func startPhoneSignIn(phoneNumber: String) async throws -> String
    func verifyPhoneOTP(verificationID: String, otp: String) async throws
    func getIdToken(forceRefresh: Bool) async throws -> String?
    func signOut() throws
}

// MARK: - FirebaseAuthRepository

@MainActor
final class FirebaseAuthRepository: ObservableObject, AuthRepository {

    static let shared = FirebaseAuthRepository()

    @Published var currentUser: FirebaseAuth.User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var authStateListener: AuthStateDidChangeListenerHandle?

    private init() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }

    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    // MARK: - AuthRepository

    var isLoggedIn: Bool { currentUser != nil }
    var currentUserId: String? { currentUser?.uid }

    // Google Sign In
    func signInWithGoogle(presenting viewController: UIViewController) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let app = FirebaseApp.app()
        let options = app?.options
        let clientid = options?.clientID
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.configurationMissing
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)

        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.tokenMissing
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )

        try await Auth.auth().signIn(with: credential)
        try await cacheIdToken()
    }

    // Apple Sign In (credential is built in ASAuthorizationController)
    func signInWithApple(credential: AuthCredential) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        try await Auth.auth().signIn(with: credential)
        try await cacheIdToken()
    }

    // Phone OTP
    func startPhoneSignIn(phoneNumber: String) async throws -> String {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        // NOTE: You can prepend +91 here or expect full E.164 format from the caller
        let verificationID = try await PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil)

        return verificationID
    }

    func verifyPhoneOTP(verificationID: String, otp: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID, verificationCode: otp)

        try await Auth.auth().signIn(with: credential)
        try await cacheIdToken()
    }

    func getIdToken(forceRefresh: Bool = false) async throws -> String? {
        guard let user = Auth.auth().currentUser else { return nil }

        let result = try await user.getIDTokenResult(forcingRefresh: forceRefresh)
        let token = result.token

        if !token.isEmpty {
            KeychainManager.shared.saveToken(token)
        }
        return token
    }

    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        KeychainManager.shared.deleteToken()
        currentUser = nil
    }

    // MARK: - Helpers

    private func cacheIdToken() async throws {
        _ = try await getIdToken(forceRefresh: true)
    }
}

// MARK: - Auth Error

enum AuthError: LocalizedError {
    case configurationMissing
    case tokenMissing
    case invalidCredential

    var errorDescription: String? {
        switch self {
        case .configurationMissing: return "Firebase configuration missing"
        case .tokenMissing: return "Authentication token not received"
        case .invalidCredential: return "Invalid credentials"
        }
    }
}
