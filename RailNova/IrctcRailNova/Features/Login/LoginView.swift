//
//  LoginView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var currentStep: AuthStep

    @State private var email = ""
    @State private var password = ""

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isFormValid: Bool {
        !trimmedEmail.isEmpty && !password.isEmpty
    }

    var body: some View {
        AuthFormContainer(
            title: "Welcome back",
            subtitle: "Login to continue your RailNova journey.",
            onBack: { currentStep = .landing }
        ) {
            AuthTextField(
                title: "Email",
                text: $email,
                keyboardType: .emailAddress,
                textContentType: .emailAddress,
                autocapitalization: .never
            )

            AuthTextField(
                title: "Password",
                text: $password,
                textContentType: .password,
                isSecure: true
            )

            if let error = authManager.errorMessage, !error.isEmpty {
                Text(error)
                    .font(RNTypography.labelMedium)
                    .foregroundColor(.railNovaError)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task {
                    await authManager.login(email: trimmedEmail, password: password)
                }
            } label: {
                Group {
                    if authManager.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .buttonStyle(PrimaryAuthButtonStyle(isEnabled: isFormValid && !authManager.isLoading))
            .disabled(!isFormValid || authManager.isLoading)

            Button {
                currentStep = .signup
            } label: {
                Text("Create account")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryAuthButtonStyle())
            .padding(.top, 4)
        }
    }
}
