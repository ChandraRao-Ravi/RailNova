//
//  IrctcRailNovaApp.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 26/05/26.
//

import SwiftUI
import Firebase

@main
struct IrctcRailNovaApp: App {
    @StateObject private var authViewModel = AuthViewModel(
        authRepository: FirebaseAuthRepository.shared
    )
    @State private var showSplash = true

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    showSplash = false
                                }
                            }
                        }
                } else if authViewModel.isLoggedIn {
                    MainTabView()
                } else {
                    AuthFlowContainerView()
                }
            }
            .environmentObject(authViewModel)
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "train.side.front.car")
                    .font(.system(size: 64))
                    .foregroundColor(.white)
                Text("RailNova")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
            }
        }
    }
}
