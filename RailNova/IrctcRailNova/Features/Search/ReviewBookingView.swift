//
//  ReviewBookingView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI

struct ReviewBookingView: View {
    let train: Train
    let journeyDate: Date
    let travelClass: TravelClass
    let quota: Quota
    let passengers: [Passenger]
    let contactEmail: String
    let contactPhone: String

    @State private var selectedPaymentMethod: PaymentMethod = .upi
    @State private var navigateToConfirmation = false
    @State private var booking: Booking?

    // Simple fare logic: per passenger fare
    private var baseFare: Double {
        Double(passengers.count) * 500   // TODO: replace 500 with travelClass-based fare if needed
    }

    private var convenienceFee: Double {
        selectedPaymentMethod.convenienceFee
    }

    private var totalAmount: Double {
        baseFare + convenienceFee
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Journey card
                RNCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(train.name) (\(train.number))")
                            .font(.headline)
                        Text(journeyDate, style: .date)
                        Text("\(travelClass.displayName) • \(quota.displayName)")
                    }
                }

                // Passengers
                RNCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Passengers")
                            .font(.headline)

                        ForEach(passengers.indices, id: \.self) { index in
                            let p = passengers[index]
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(p.name)
                                    Text("Age \(p.age) • \(p.gender.rawValue)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(p.berthPreference.displayName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                // Fare summary
                RNCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fare summary")
                            .font(.headline)

                        HStack {
                            Text("Ticket fare")
                            Spacer()
                            Text("₹\(Int(baseFare))")
                        }

                        HStack {
                            Text("Convenience fee (\(selectedPaymentMethod.rawValue))")
                            Spacer()
                            Text("₹\(Int(convenienceFee))")
                        }

                        Divider()

                        HStack {
                            Text("Total amount")
                                .font(.headline)
                            Spacer()
                            Text("₹\(Int(totalAmount))")
                                .font(.headline)
                        }
                    }
                }

                // Payment method
                RNCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Payment method")
                            .font(.headline)

                        Picker("Payment method", selection: $selectedPaymentMethod) {
                            ForEach(PaymentMethod.allCases, id: \.self) { method in
                                Text(method.rawValue).tag(method)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Review Journey")
        .safeAreaInset(edge: .bottom) {
            VStack {
                NavigationLink(
                    destination: BookingConfirmationView(booking: booking),
                    isActive: $navigateToConfirmation
                ) {
                    EmptyView()
                }
                .hidden()

                RNPrimaryButton("Proceed to Pay", icon: "creditcard") {
                    let newBooking = createMockBooking()
                    self.booking = newBooking
                    self.navigateToConfirmation = true
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }

    private func createMockBooking() -> Booking {
        // We don't have real seats now, so allocate placeholder seat numbers and use berthPreference
        let passengerBookings: [PassengerBooking] = passengers.enumerated().map { index, passenger in
            PassengerBooking(
                id: UUID().uuidString,
                passenger: passenger,
                coachNumber: "CNF",            // placeholder coach
                seatNumber: index + 1,         // placeholder seat number
                berthType: passenger.berthPreference,
                confirmationStatus: .confirmed
            )
        }

        return Booking(
            id: UUID().uuidString,
            pnrNumber: String(Int.random(in: 1_000_000_000...9_999_999_999)),
            train: train,
            journeyDate: journeyDate,
            passengers: passengerBookings,
            travelClass: travelClass,
            quota: quota,
            totalFare: baseFare,
            convenienceFee: convenienceFee,
            status: .confirmed,
            bookedAt: Date(),
            chartStatus: .notPrepared
        )
    }
}
