//
//  AuthFlowContainerView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 26/05/26.
//

import SwiftUI

struct AuthFlowContainerView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        switch authVM.currentStep {
        case .landing:
            AuthView()
        case .phoneEntry:
            PhoneEntryView()
        case .otpVerification:
            OTPVerificationView()
        case .complete:
            AuthView()   // or a small success screen, then auto-dismiss
        }
    }
}
