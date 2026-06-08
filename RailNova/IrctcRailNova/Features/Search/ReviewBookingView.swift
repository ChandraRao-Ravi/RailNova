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
    let fromStation: Station
    let toStation: Station

    @State private var selectedPaymentMethod: PaymentMethod = .upi
    @State private var navigateToPayment = false
    @State private var booking: Booking?
    @EnvironmentObject var authManager: AuthManager

    @Binding var selectedTab: MainTab

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
                // Hidden NavigationLink driven by state
                NavigationLink(
                    destination: PaymentView(
                        train: train,
                        journeyDate: journeyDate,
                        fromStation: fromStation,
                        toStation: toStation,
                        totalFare: totalAmount,
                        authManager: authManager
                    ) { booking in
                        selectedTab = MainTab.bookings
                    },
                    isActive: $navigateToPayment
                ) {
                    EmptyView()
                }
                .hidden()
                
                // Visible button
                RNPrimaryButton("Proceed to Pay", icon: "creditcard") {
                    navigateToPayment = true
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}
