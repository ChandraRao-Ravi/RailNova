import Foundation

// MARK: - Booking Models

struct Booking: Identifiable, Codable {
    let id: String
    let pnrNumber: String
    let train: Train
    let journeyDate: Date
    let passengers: [PassengerBooking]
    let travelClass: TravelClass
    let quota: Quota
    let totalFare: Double
    let convenienceFee: Double
    var status: BookingStatus
    let bookedAt: Date
    let chartStatus: ChartStatus
    
    var totalAmount: Double { totalFare + convenienceFee }
}

struct PassengerBooking: Identifiable, Codable {
    let id: String
    let passenger: Passenger
    let coachNumber: String
    let seatNumber: Int
    let berthType: BerthType
    var confirmationStatus: ConfirmationStatus
}

enum BookingStatus: String, Codable {
    case confirmed = "CNF"
    case waitlist = "WL"
    case rac = "RAC"
    case cancelled = "CAN"
    case completed = "COMPLETED"
    
    var displayText: String { rawValue }
    
    var color: String {
        switch self {
        case .confirmed: return "green"
        case .waitlist: return "orange"
        case .rac: return "yellow"
        case .cancelled: return "red"
        case .completed: return "gray"
        }
    }
}

enum ConfirmationStatus: String, Codable {
    case confirmed = "CNF"
    case waitlist = "WL"
    case rac = "RAC"
}

enum ChartStatus: String, Codable {
    case notPrepared = "Chart Not Prepared"
    case prepared = "Chart Prepared"
}

// MARK: - Payment Models

struct PaymentRequest {
    let bookingId: String
    let amount: Double
    let method: PaymentMethod
    let currency: String = "INR"
}

enum PaymentMethod: String, CaseIterable {
    case upi = "UPI"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case netBanking = "Net Banking"
    case wallet = "Wallet"
    case payLater = "Pay Later"
    
    var convenienceFee: Double {
        switch self {
        case .upi: return 20.0
        default: return 30.0
        }
    }
}

struct PaymentResult {
    let success: Bool
    let transactionId: String?
    let pnrNumber: String?
    let errorMessage: String?
}
