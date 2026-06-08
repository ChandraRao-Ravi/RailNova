//
//  AuthManager.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import AuthenticationServices
import SwiftUI

struct AuthView: View {
    @Binding var currentStep: AuthStep
    @EnvironmentObject var authManager: AuthManager
    @State private var appleCoordinator: AppleSignInCoordinator?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.railNovaPrimary, Color.railNovaSecondary.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "tram.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                    
                    Text("RailNova")
                        .font(RNTypography.displayLarge)
                        .foregroundColor(.white)
                    
                    Text("Your journey, simplified.")
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.white.opacity(0.72))
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        currentStep = .login
                    } label: {
                        AuthButtonLabel(
                            icon: "envelope.fill",
                            title: "Login with Email",
                            foreground: .black
                        )
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    
                    Button {
                        currentStep = .signup
                    } label: {
                        AuthButtonLabel(
                            icon: "person.badge.plus.fill",
                            title: "Create Account",
                            foreground: .white
                        )
                        .background(Color.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    
                    Button {
                        Task {
                            await authManager.loginWithGoogle()
                        }
                    } label: {
                        AuthButtonLabel(
                            icon: "globe",
                            title: "Continue with Google",
                            foreground: .black
                        )
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(authManager.isLoading)
                    
                    Button {
                        Task {
                            await authManager.loginWithApple()
                        }
                    } label: {
                        AuthButtonLabel(
                            icon: "applelogo",
                            title: "Continue with Apple",
                            foreground: .white
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(authManager.isLoading)
                    
                    if authManager.isLoading {
                        ProgressView()
                            .tint(.white)
                            .padding(.top, 8)
                    }
                    
                    if let error = authManager.errorMessage, !error.isEmpty {
                        Text(error)
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.red.opacity(0.95))
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }

                    Text("By continuing you agree to our Terms & Conditions and Privacy Policy")
                        .font(RNTypography.labelMedium)
                        .foregroundColor(.white.opacity(0.68))
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}
