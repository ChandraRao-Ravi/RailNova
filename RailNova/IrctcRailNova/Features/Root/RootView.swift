//
//  RootView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 08/06/26.
//

import Foundation
import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            if authManager.isLoading && authManager.currentUser == nil && !authManager.isAuthenticated {
                ProgressView("Loading...")
            } else if authManager.isAuthenticated {
                MainTabView()
            } else {
                AuthFlowContainerView()
            }
        }
        .task {
            await authManager.restoreSession()
        }
    }
}
