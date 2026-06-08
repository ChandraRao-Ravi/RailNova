//
//  SignupView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var currentStep: AuthStep

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    private var trimmedFullName: String {
        fullName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var passwordsMatch: Bool {
        !confirmPassword.isEmpty && password == confirmPassword
    }

    private var isFormValid: Bool {
        !trimmedFullName.isEmpty &&
        !trimmedEmail.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }

    var body: some View {
        AuthFormContainer(
            title: "Create account",
            subtitle: "Set up your RailNova profile and start booking faster.",
            onBack: { currentStep = .landing }
        ) {
            AuthTextField(
                title: "Full Name",
                text: $fullName,
                textContentType: .name,
                autocapitalization: .words
            )

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
                textContentType: .newPassword,
                isSecure: true
            )

            AuthTextField(
                title: "Confirm Password",
                text: $confirmPassword,
                textContentType: .newPassword,
                isSecure: true
            )

            if !confirmPassword.isEmpty && !passwordsMatch {
                Text("Passwords do not match")
                    .font(RNTypography.labelMedium)
                    .foregroundColor(.railNovaError)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let error = authManager.errorMessage, !error.isEmpty {
                Text(error)
                    .font(RNTypography.labelMedium)
                    .foregroundColor(.railNovaError)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task {
                    await authManager.signup(
                        fullName: trimmedFullName,
                        email: trimmedEmail,
                        password: password
                    )
                }
            } label: {
                Group {
                    if authManager.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .buttonStyle(PrimaryAuthButtonStyle(isEnabled: isFormValid && !authManager.isLoading))
            .disabled(!isFormValid || authManager.isLoading)

            Button {
                currentStep = .login
            } label: {
                Text("Already have an account? Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryAuthButtonStyle())
            .padding(.top, 4)
        }
    }
}
