import SwiftUI
import FirebaseCore

@main
struct RailNovaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isLoggedIn {
                    MainTabView()
                } else {
                    AuthView()
                }
            }
            .environmentObject(authViewModel)
        }
    }
}
