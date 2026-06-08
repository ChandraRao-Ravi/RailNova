//
//  PaymentViewModel.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class PaymentViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var booking: Booking?   // your UI model
    @Published var errorMessage: String?
    @Published var isProcessing = false
    
    private let bookingService = BookingService.shared
    let authManager: AuthManager  // injected
    
    init(
        authManager: AuthManager
    ) {
        self.authManager = authManager
    }
    
    func confirmBooking(train: Train,
                        journeyDate: Date,
                        fromStation: Station,
                        toStation: Station,
                        totalFare: Double) async {
        guard let user = authManager.currentUser else {
            errorMessage = "Please login to continue."
            return
        }

        isLoading = true
        defer { isLoading = false }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // or match backend string you're using

        let req = BookingCreateRequest(
            userId: user.id,                 // or email if that’s what you use
            trainNumber: train.number,
            journeyDate: formatter.string(from: journeyDate),
            from: fromStation.code,
            to: toStation.code,
            totalFare: totalFare
        )

        do {
            let dto = try await bookingService.createBooking(request: req)
            
            // Minimal Train placeholder using only number + stations for now
            let train = Train(
                number: dto.train_number ?? "",
                name: "Train \(dto.train_number ?? "")",
                from: dto.from_station ?? "",
                to: dto.to_station ?? "",
                departureTime: "--:--",
                arrivalTime: "--:--",
                durationMinutes: 0,
                daysOfOperation: [],
                classes: []
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let date = formatter.date(from: dto.journeyDate ?? "") ?? Date()
            let fare = Double(dto.total_fare ?? "0")

            // Map DTO -> your Booking model
            let confirmed = Booking(
                id: dto.id ?? "",
                pnrNumber: dto.pnr ?? "",
                train: train,
                journeyDate: journeyDate,
                passengers: [],         // fill from your passenger form
                travelClass: .sleeperClass,
                quota: .general,
                totalFare: fare ?? 0.0,
                convenienceFee: 0,
                status: .confirmed,
                bookedAt: Date(),
                chartStatus: .notPrepared
            )
            self.booking = confirmed
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
