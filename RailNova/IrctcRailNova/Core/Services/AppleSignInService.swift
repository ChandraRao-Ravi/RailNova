//
//  AppleSignInService.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import FirebaseAuth
import Foundation

final class AppleSignInService {
    static let shared = AppleSignInService()
    private init() {}

    func signInAndGetFirebaseToken() async throws -> String {
        let coordinator = AppleSignInCoordinator()
        let result = try await coordinator.startSignIn()

        let credential = OAuthProvider.credential(
            providerID: AuthProviderID.apple,
            idToken: result.identityToken,
            rawNonce: result.rawNonce
        )

        _ = try await Auth.auth().signIn(with: credential)

        guard let firebaseUser = Auth.auth().currentUser else {
            throw NetworkError.unauthorized
        }

        return try await firebaseUser.getIDToken()
    }
}
