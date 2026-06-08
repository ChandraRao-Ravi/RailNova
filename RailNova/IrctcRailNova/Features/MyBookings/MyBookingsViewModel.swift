//
//  MyBookingsViewModel.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//
import Combine
import Foundation
import SwiftUI

@MainActor
final class MyBookingsViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let bookingService = BookingService.shared
    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    func loadBookings() async {
        guard let user = authManager.currentUser else {
            errorMessage = "Please login to see your bookings."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let dtos = try await bookingService.getBookings(for: user.id)
            self.bookings = dtos.map { dto in
                
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
                
                return Booking(
                    id: dto.id ?? "",
                    pnrNumber: dto.pnr ?? "PNR_NA",
                    train: train,
                    journeyDate: date,
                    passengers: [],
                    travelClass: TravelClass.sleeperClass,
                    quota: .general,
                    totalFare: fare ?? 0.00,
                    convenienceFee: 0,
                    status: .confirmed,
                    bookedAt: Date(),
                    chartStatus: .notPrepared
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
