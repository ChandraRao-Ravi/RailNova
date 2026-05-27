//
//  BookingViewModel.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI
import Combine

@MainActor
final class BookingViewModel: ObservableObject {

    // MARK: - State
    @Published var currentStep: BookingStep = .passengerDetails

    // Passenger Details
    @Published var passengers: [Passenger] = [
        Passenger(
            id: UUID().uuidString,
            name: "",
            age: 0,
            gender: .male,
            berthPreference: .noPreference
        )
    ]
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
        return trainClass.fare ?? 0.00 * Double(passengers.count)
    }

    var convenienceFee: Double { selectedPaymentMethod.convenienceFee }
    var totalAmount: Double { totalFare + convenienceFee }

    var canProceedToPassengers: Bool {
        // With no seat selection, you can proceed as long as there is at least one passenger row
        !passengers.isEmpty
    }

    var canProceedToPayment: Bool {
        passengers.allSatisfy { !$0.name.isEmpty && $0.age > 0 } &&
        contactPhone.count == 10
    }

    // MARK: - Actions

    func addPassenger() {
        guard passengers.count < 6 else { return }  // Max 6 passengers per booking
        passengers.append(
            Passenger(
                id: UUID().uuidString,
                name: "",
                age: 0,
                gender: .male,
                berthPreference: .noPreference
            )
        )
    }

    func removePassenger(at index: Int) {
        guard passengers.count > 1 else { return }
        passengers.remove(at: index)
    }

    func proceedToStep(_ step: BookingStep) {
        currentStep = step
    }

    // You can add a method to create Booking using passengers + context like in ReviewBookingView
}

enum BookingStep: Int, CaseIterable {
    case passengerDetails = 0
    case reviewJourney = 1
    case payment = 2
    case confirmed = 3

    var title: String {
        switch self {
        case .passengerDetails: return "Passenger Details"
        case .reviewJourney: return "Review Journey"
        case .payment: return "Payment"
        case .confirmed: return "Confirmed"
        }
    }
}
