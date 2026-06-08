//
//  AuthButtonLabel.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import SwiftUI

struct AuthButtonLabel: View {
    let icon: String
    let title: String
    let foreground: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))

            Text(title)
                .font(RNTypography.buttonLarge)
        }
        .foregroundColor(foreground)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
    }
}
