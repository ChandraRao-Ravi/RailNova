//
//  GoogleSignInService.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

enum SocialAuthError: LocalizedError {
    case missingRootViewController
    case missingIDToken
    case invalidAppleCredential
    
    var errorDescription: String? {
        switch self {
        case .missingRootViewController:
            return "Unable to find a presenting view controller."
        case .missingIDToken:
            return "Identity token was not received."
        case .invalidAppleCredential:
            return "Invalid Apple credential."
        }
    }
}

final class GoogleSignInService {
    static let shared = GoogleSignInService()
    private init() {}

    func signInAndGetFirebaseToken() async throws -> String {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NetworkError.serverError(500, "Missing Firebase client ID.")
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let rootVC = await UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: \.isKeyWindow)?
            .rootViewController else {
            throw SocialAuthError.missingRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)

        guard let idToken = result.user.idToken?.tokenString else {
            throw SocialAuthError.missingIDToken
        }

        let accessToken = result.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

        _ = try await Auth.auth().signIn(with: credential)

        guard let firebaseUser = Auth.auth().currentUser else {
            throw NetworkError.unauthorized
        }

        return try await firebaseUser.getIDToken()
    }

    func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
}
