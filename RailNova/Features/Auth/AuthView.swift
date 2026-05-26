import SwiftUI

// MARK: - Auth View

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.rnPrimary, Color.rnSecondary.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Logo & Title
                VStack(spacing: 12) {
                    Image(systemName: "tram.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                    Text("RailNova")
                        .font(RNTypography.displayLarge)
                        .foregroundColor(.white)
                    Text("Your journey, simplified.")
                        .font(RNTypography.bodyLarge)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Auth Buttons
                VStack(spacing: 12) {
                    // Google Sign In
                    Button {
                        // TODO: Pass UIViewController
                    } label: {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .font(.title2)
                            Text("Continue with Google")
                                .font(RNTypography.labelLarge)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                    
                    // Apple Sign In
                    Button {
                        // TODO: Apple Sign In
                    } label: {
                        HStack {
                            Image(systemName: "apple.logo")
                                .font(.title2)
                            Text("Continue with Apple")
                                .font(RNTypography.labelLarge)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    // Phone Sign In
                    Button {
                        authVM.currentStep = .phoneEntry
                    } label: {
                        HStack {
                            Image(systemName: "phone.fill")
                                .font(.title2)
                            Text("Continue with Phone")
                                .font(RNTypography.labelLarge)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.15))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    Text("By continuing you agree to our Terms & Conditions and Privacy Policy")
                        .font(RNTypography.labelSmall)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}
