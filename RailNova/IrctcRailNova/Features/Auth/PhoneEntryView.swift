//
//  PhoneEntryView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 26/05/26.
//

import SwiftUI

struct PhoneEntryView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Verify your mobile number")
                .font(RNTypography.headlineLarge)

            HStack {
                Text("+91")
                TextField("Enter 10-digit mobile", text: $authVM.phoneNumber)
                    .keyboardType(.numberPad)
            }
            .padding()
            .background(Color.railNovaSurface)
            .cornerRadius(12)

            RNPrimaryButton(
                "Send OTP",
                icon: "paperplane",
                isDisabled: authVM.phoneNumber.count != 10
            ) {
                Task { await authVM.sendOTP() }
            }

            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(RNTypography.bodySmall)
            }

            Spacer()
        }
        .padding()
    }
}

// OTP Verification
struct OTPVerificationView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Enter OTP")
                .font(RNTypography.headlineLarge)

            TextField("6-digit OTP", text: $authVM.otpCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.railNovaSurface)
                .cornerRadius(12)

            RNPrimaryButton(
                "Verify & Continue",
                icon: "checkmark",
                isDisabled: authVM.otpCode.count != 6
            ) {
                Task { await authVM.verifyOTP() }
            }

            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(RNTypography.bodySmall)
            }

            Spacer()
        }
        .padding()
    }
}
