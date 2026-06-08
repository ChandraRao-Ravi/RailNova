//
//  AuthFormContainer.swift
//  
//
//  Created by Chandra Rao on 08/06/26.
//

import SwiftUI

struct AuthFormContainer<Content: View>: View {
    let title: String
    let subtitle: String
    let onBack: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [Color.railNovaPrimary, Color.railNovaSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "train.side.front.car")
                            .symbolRenderingMode(.hierarchical)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 220)
                            .foregroundStyle(.white)
                            .opacity(0.05)
                            .rotationEffect(.degrees(-12))
                            .offset(x: 50, y: 40)
                            .allowsHitTesting(false)
                    }
                }
                .ignoresSafeArea()

                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.14))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        )
                }
                .padding(.leading, 20)
                .padding(.top, 44)

            VStack {
                Spacer(minLength: 36)

                VStack(spacing: 10) {
                    Text(title)
                        .font(RNTypography.displayMedium)
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(RNTypography.bodyMedium)
                        .foregroundColor(.white.opacity(0.72))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 28)

                VStack(spacing: 16) {
                    content
                }
                .padding(24)
                .background(Color.white.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.black.opacity(0.10), radius: 24, y: 10)
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.bottom, 28)
        }
    }
}

struct AuthInputStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(RNTypography.bodyLarge)
            .foregroundColor(.railNovaTextPrimary)
            .padding(.horizontal, 18)
            .frame(height: 56)
            .background(Color.white.opacity(0.96))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

extension View {
    func authInputStyle() -> some View {
        modifier(AuthInputStyle())
    }
}

struct PrimaryAuthButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(RNTypography.buttonLarge)
            .foregroundColor(isEnabled ? .white : .white.opacity(0.75))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                isEnabled
                ? LinearGradient(
                    colors: [Color.railNovaSecondary, Color.railNovaPrimary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                : LinearGradient(
                    colors: [Color.white.opacity(0.22), Color.white.opacity(0.16)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .opacity(configuration.isPressed ? 0.92 : 1)
    }
}

struct SecondaryAuthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(RNTypography.buttonLarge)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.white.opacity(configuration.isPressed ? 0.16 : 0.10))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.22), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
