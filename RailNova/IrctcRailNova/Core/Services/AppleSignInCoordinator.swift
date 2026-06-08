//
//  AppleSignInCoordinator.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Foundation
import UIKit

struct AppleSignInResult {
    let identityToken: String
    let authorizationCode: String?
    let rawNonce: String
}

final class AppleSignInCoordinator: NSObject {
    private var continuation: CheckedContinuation<AppleSignInResult, Error>?
    private var currentNonce: String?

    func startSignIn() async throws -> AppleSignInResult {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let rawNonce = AppleNonce.randomNonceString()
            currentNonce = rawNonce

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = AppleNonce.sha256(rawNonce)

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

extension AppleSignInCoordinator: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: SocialAuthError.invalidAppleCredential)
            continuation = nil
            return
        }

        guard
            let tokenData = credential.identityToken,
            let identityToken = String(data: tokenData, encoding: .utf8)
        else {
            continuation?.resume(throwing: SocialAuthError.missingIDToken)
            continuation = nil
            return
        }

        guard let rawNonce = currentNonce else {
            continuation?.resume(throwing: SocialAuthError.invalidAppleCredential)
            continuation = nil
            return
        }

        let authorizationCode = credential.authorizationCode
            .flatMap { String(data: $0, encoding: .utf8) }

        continuation?.resume(
            returning: AppleSignInResult(
                identityToken: identityToken,
                authorizationCode: authorizationCode,
                rawNonce: rawNonce
            )
        )
        continuation = nil
        currentNonce = nil
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
        currentNonce = nil
    }
}

extension AppleSignInCoordinator: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
