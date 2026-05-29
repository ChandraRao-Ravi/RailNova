//
//  PaymentView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import Combine
import SwiftUI
import Foundation

struct PaymentView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: PaymentViewModel

    let train: Train
    let journeyDate: Date
    let fromStation: Station
    let toStation: Station
    let totalFare: Double
    let onBookingConfirmed: (Booking) -> Void

    init(train: Train,
         journeyDate: Date,
         fromStation: Station,
         toStation: Station,
         totalFare: Double,
         authVM: AuthViewModel,
         onBookingConfirmed: @escaping (Booking) -> Void) {
        self.train = train
        self.journeyDate = journeyDate
        self.fromStation = fromStation
        self.toStation = toStation
        self.totalFare = totalFare
        self.onBookingConfirmed = onBookingConfirmed

        // vm will be initialized in body once we have authVM
        _vm = StateObject(wrappedValue: PaymentViewModel(authVM: authVM))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Summary
            RNCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Payment summary")
                        .font(RNTypography.bodyMedium)
                        .foregroundColor(.railNovaTextSecondary)

                    Text("\(train.number) • \(train.name)")
                        .font(RNTypography.bodyLarge)

                    Text("\(fromStation.code) → \(toStation.code)")
                        .font(RNTypography.bodySmall)
                        .foregroundColor(.railNovaTextMuted)

                    Text(journeyDate, style: .date)
                        .font(RNTypography.labelSmall)
                        .foregroundColor(.railNovaTextMuted)

                    HStack {
                        Text("Total amount")
                            .font(RNTypography.bodyMedium)
                        Spacer()
                        Text("₹\(Int(totalFare))")
                            .font(RNTypography.headlineSmall)
                    }
                }
            }
            .padding()

            Spacer()

            if let error = vm.errorMessage {
                Text(error)
                    .font(RNTypography.labelSmall)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            // Pay button
            RNPrimaryButton(
                vm.isProcessing ? "Processing..." : "Pay & Book",
                isDisabled: vm.isProcessing
            ) {
                Task {
                    await vm.confirmBooking(
                        train: train,
                        journeyDate: journeyDate,
                        fromStation: fromStation,
                        toStation: toStation,
                        totalFare: totalFare
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if vm.isProcessing {
                Color.black.opacity(0.2).ignoresSafeArea()
                ProgressView()
            }
        }
        .onReceive(vm.$booking.compactMap { $0 }) { booking in
            onBookingConfirmed(booking)
            dismiss()
        }
    }
}
