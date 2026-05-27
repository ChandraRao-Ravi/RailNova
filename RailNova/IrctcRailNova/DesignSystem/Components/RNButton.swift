import SwiftUI

// MARK: - RailNova Primary Button

struct RNPrimaryButton: View {
    let title: String
    let icon: String?
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, isLoading: Bool = false, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.8)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(RNTypography.labelLarge)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isDisabled ? Color.gray.opacity(0.4) : Color.railNovaSecondary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - RailNova Secondary Button

struct RNSecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(RNTypography.labelLarge)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.railNovaSecondary.opacity(0.12))
            .foregroundColor(.railNovaSecondary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.railNovaSecondary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Class Availability Badge

struct AvailabilityBadge: View {
    let travelClass: TravelClass
    let status: AvailabilityStatus
    let fare: Double
    let isSelected: Bool
    let onTap: () -> Void
    
    var statusColor: Color {
        switch status {
        case .available: return .railNovaAvailable
        case .waitlist: return .railNovaWaitlist
        case .rac: return .railNovaRAC
        case .notAvailable: return .gray
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(travelClass.rawValue)
                    .font(RNTypography.labelLarge)
                    .foregroundColor(isSelected ? .white : .railNovaTextPrimary)
                Text(status.displayText)
                    .font(RNTypography.labelSmall)
                    .foregroundColor(isSelected ? .white.opacity(0.9) : statusColor)
                Text("₹\(Int(fare))")
                    .font(RNTypography.labelMedium)
                    .foregroundColor(isSelected ? .white : .railNovaTextSecondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.railNovaSecondary : Color.railNovaCardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .disabled(!status.isBookable)
    }
}
