//
//  AuthFlowContainerView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 26/05/26.
//

import SwiftUI

struct AuthFlowContainerView: View {
    @State private var currentStep: AuthStep = .landing

    var body: some View {
        switch currentStep {
        case .landing:
            AuthView(currentStep: $currentStep)

        case .login:
            LoginView(currentStep: $currentStep)

        case .signup:
            SignupView(currentStep: $currentStep)

        }
    }
}
