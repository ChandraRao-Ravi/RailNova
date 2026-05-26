import SwiftUI
import Combine

// MARK: - Auth ViewModel

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentStep: AuthStep = .landing
    
    // Phone OTP flow
    @Published var phoneNumber = ""
    @Published var otpCode = ""
    @Published var verificationID = ""
    
    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        authService.$currentUser
            .map { $0 != nil }
            .assign(to: &$isLoggedIn)
    }
    
    func sendOTP() async {
        guard phoneNumber.count == 10 else {
            errorMessage = "Please enter a valid 10-digit mobile number"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            verificationID = try await authService.sendOTP(to: phoneNumber)
            currentStep = .otpVerification
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func verifyOTP() async {
        guard otpCode.count == 6 else {
            errorMessage = "Please enter the 6-digit OTP"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            try await authService.verifyOTP(verificationID: verificationID, otp: otpCode)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signOut() {
        do {
            try authService.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

enum AuthStep {
    case landing
    case phoneEntry
    case otpVerification
    case complete
}
