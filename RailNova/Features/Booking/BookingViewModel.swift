import SwiftUI
import Combine

// MARK: - Booking ViewModel

@MainActor
final class BookingViewModel: ObservableObject {
    
    // MARK: - State
    @Published var currentStep: BookingStep = .seatSelection
    
    // Seat Selection
    @Published var coachLayout: CoachLayout?
    @Published var selectedSeats: [Seat] = []
    @Published var isLoadingLayout = false
    
    // Passenger Details
    @Published var passengers: [Passenger] = [Passenger(id: UUID().uuidString, name: "", age: 0, gender: .male, berthPreference: .noPreference)]
    @Published var contactPhone = ""
    @Published var contactEmail = ""
    @Published var gstNumber = ""
    @Published var autoUpgradation = false
    @Published var optOutMeals = false
    
    // Payment
    @Published var selectedPaymentMethod: PaymentMethod = .upi
    @Published var isProcessingPayment = false
    
    // Result
    @Published var confirmedBooking: Booking?
    @Published var errorMessage: String?
    
    // Context
    var selectedTrain: Train?
    var selectedTrainClass: TrainClass?
    var journeyDate: Date = Date()
    var selectedQuota: Quota = .general
    
    private let trainService = TrainService.shared
    
    // MARK: - Computed
    var totalFare: Double {
        guard let trainClass = selectedTrainClass else { return 0 }
        return trainClass.fare * Double(passengers.count)
    }
    
    var convenienceFee: Double { selectedPaymentMethod.convenienceFee }
    var totalAmount: Double { totalFare + convenienceFee }
    
    var canProceedToPassengers: Bool {
        !selectedSeats.isEmpty && selectedSeats.count == passengers.count
    }
    
    var canProceedToPayment: Bool {
        passengers.allSatisfy { !$0.name.isEmpty && $0.age > 0 } &&
        contactPhone.count == 10
    }
    
    // MARK: - Actions
    func loadCoachLayout() async {
        guard let train = selectedTrain, let trainClass = selectedTrainClass else { return }
        isLoadingLayout = true
        do {
            coachLayout = try await trainService.getCoachLayout(
                trainNumber: train.number,
                coachType: trainClass.type,
                date: journeyDate
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingLayout = false
    }
    
    func toggleSeatSelection(_ seat: Seat) {
        if let index = selectedSeats.firstIndex(where: { $0.id == seat.id }) {
            selectedSeats.remove(at: index)
        } else if selectedSeats.count < passengers.count {
            selectedSeats.append(seat)
        }
    }
    
    func addPassenger() {
        guard passengers.count < 6 else { return }  // Max 6 passengers per booking
        passengers.append(Passenger(id: UUID().uuidString, name: "", age: 0, gender: .male, berthPreference: .noPreference))
    }
    
    func removePassenger(at index: Int) {
        guard passengers.count > 1 else { return }
        passengers.remove(at: index)
    }
    
    func proceedToStep(_ step: BookingStep) {
        currentStep = step
    }
}

enum BookingStep: Int, CaseIterable {
    case seatSelection = 0
    case passengerDetails = 1
    case reviewJourney = 2
    case payment = 3
    case confirmed = 4
    
    var title: String {
        switch self {
        case .seatSelection: return "Select Seats"
        case .passengerDetails: return "Passenger Details"
        case .reviewJourney: return "Review Journey"
        case .payment: return "Payment"
        case .confirmed: return "Confirmed"
        }
    }
}
