//
//  AuthTextField.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import SwiftUI

struct AuthTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autocapitalization: TextInputAutocapitalization = .sentences
    var isSecure: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(title)
                    .font(RNTypography.bodyLarge)
                    .foregroundColor(Color.black.opacity(0.34))
                    .padding(.horizontal, 18)
            }

            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                        .textInputAutocapitalization(autocapitalization)
                        .keyboardType(keyboardType)
                        .autocorrectionDisabled()
                }
            }
            .font(RNTypography.bodyLarge)
            .foregroundColor(.railNovaTextPrimary)
            .textContentType(textContentType)
            .padding(.horizontal, 18)
        }
        .frame(height: 56)
        .background(Color.white.opacity(0.96))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
