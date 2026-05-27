import Combine
import FirebaseAuth
import SwiftUI

enum AuthStep {
    case landing
    case phoneEntry
    case otpVerification
    case complete
}

@MainActor
final class AuthViewModel: ObservableObject {

    @Published var currentUser: UserProfile?
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentStep: AuthStep = .landing

    // Phone OTP flow
    @Published var phoneNumber = ""
    @Published var otpCode = ""
    @Published var verificationID = ""

    private let authRepository: FirebaseAuthRepository   // still concrete for now
    private var cancellables = Set<AnyCancellable>()

    init(authRepository: FirebaseAuthRepository) {
        self.authRepository = authRepository

        authRepository.$currentUser
            .map { $0 != nil }
            .assign(to: &$isLoggedIn)

        authRepository.$isLoading
            .assign(to: &$isLoading)

        authRepository.$errorMessage
            .assign(to: &$errorMessage)
        observeAuthUser()
    }

    // MARK: - Google Sign In

    func signInWithGoogle(from controller: UIViewController) async {
        do {
            try await authRepository.signInWithGoogle(presenting: controller)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Phone OTP

    func sendOTP() async {
        guard phoneNumber.count == 10 else {
            errorMessage = "Please enter a valid 10-digit mobile number"
            return
        }
        do {
            // assuming +91; adjust if you want full E.164 from input
            verificationID = try await authRepository.startPhoneSignIn(
                phoneNumber: "+91\(phoneNumber)"
            )
            currentStep = .otpVerification
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func verifyOTP() async {
        guard otpCode.count == 6 else {
            errorMessage = "Please enter the 6-digit OTP"
            return
        }
        do {
            try await authRepository.verifyPhoneOTP(
                verificationID: verificationID,
                otp: otpCode
            )
            currentStep = .complete
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Logout

    func signOut() {
        do {
            try authRepository.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private extension AuthViewModel {
    func observeAuthUser() {
        authRepository.$currentUser
            .map { firebaseUser -> UserProfile? in
                guard let user = firebaseUser else { return nil }
                return UserProfile(
                    id: user.uid,
                    name: user.displayName ?? "Guest",
                    email: user.email,
                    photoURL: user.photoURL
                )
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentUser)
    }
}
