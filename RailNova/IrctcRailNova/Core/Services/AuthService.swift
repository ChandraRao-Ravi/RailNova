import Combine
import Foundation
import Firebase
import GoogleSignIn

// MARK: - Auth Service

@MainActor
final class AuthService: ObservableObject {
    
    static let shared = AuthService()
    
    @Published var currentUser: FirebaseAuth.User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    private init() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    var isLoggedIn: Bool { currentUser != nil }
    
    // MARK: - Google Sign In
    func signInWithGoogle(presenting viewController: UIViewController) async throws {
        isLoading = true
        defer { isLoading = false }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.configurationMissing
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.tokenMissing
        }
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
        try await Auth.auth().signIn(with: credential)
    }
    
    // MARK: - Apple Sign In
    func signInWithApple(credential: AuthCredential) async throws {
        isLoading = true
        defer { isLoading = false }
        try await Auth.auth().signIn(with: credential)
    }
    
    // MARK: - Phone OTP
    func sendOTP(to phoneNumber: String) async throws -> String {
        isLoading = true
        defer { isLoading = false }
        let verificationID = try await PhoneAuthProvider.provider()
            .verifyPhoneNumber("+91\(phoneNumber)", uiDelegate: nil)
        return verificationID
    }
    
    func verifyOTP(verificationID: String, otp: String) async throws {
        isLoading = true
        defer { isLoading = false }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )
        try await Auth.auth().signIn(with: credential)
    }
    
    // MARK: - Logout
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        KeychainManager.shared.deleteToken()
    }
}
