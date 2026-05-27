import SwiftUI

// MARK: - RailNova Typography System

struct RNTypography {
    
    // MARK: - Display
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    
    // MARK: - Headline
    static let headlineLarge = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headlineSmall = Font.system(size: 18, weight: .semibold, design: .rounded)
    
    // MARK: - Body
    static let bodyLarge = Font.system(size: 16, weight: .regular)
    static let bodyMedium = Font.system(size: 14, weight: .regular)
    static let bodySmall = Font.system(size: 12, weight: .regular)
    
    // MARK: - Label
    static let labelLarge = Font.system(size: 14, weight: .medium)
    static let labelMedium = Font.system(size: 12, weight: .medium)
    static let labelSmall = Font.system(size: 10, weight: .medium)
    
    // MARK: - Train-specific
    static let trainTime = Font.system(size: 22, weight: .bold, design: .monospaced)
    static let trainNumber = Font.system(size: 13, weight: .semibold)
    static let fareDisplay = Font.system(size: 18, weight: .bold)
    static let pnrNumber = Font.system(size: 24, weight: .bold, design: .monospaced)
    static let stationCode = Font.system(size: 20, weight: .bold, design: .rounded)
}
