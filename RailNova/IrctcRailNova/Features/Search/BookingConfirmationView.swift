//
//  BookingConfirmationView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI

struct BookingConfirmationView: View {
    let booking: Booking?

    var body: some View {
        Group {
            if let booking {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        RNCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ticket booked successfully")
                                    .font(.title3)
                                Text("PNR: \(booking.pnrNumber)")
                                    .font(.headline)
                                Text("Status: \(booking.status.displayText)")
                            }
                        }

                        RNCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(booking.train.name) (\(booking.train.number))")
                                    .font(.headline)
                                Text(booking.journeyDate, style: .date)
                                Text("\(booking.travelClass.displayName) • \(booking.quota.displayName)")
                            }
                        }

                        RNCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Passengers")
                                    .font(.headline)

                                ForEach(booking.passengers) { pb in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(pb.passenger.name)
                                            Text("Age \(pb.passenger.age) • \(pb.passenger.gender.rawValue)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            Text("\(pb.coachNumber) / \(pb.seatNumber)")
                                            Text(pb.berthType.rawValue)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }

                        RNCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Fare details")
                                    .font(.headline)
                                HStack {
                                    Text("Ticket fare")
                                    Spacer()
                                    Text("₹\(Int(booking.totalFare))")
                                }
                                HStack {
                                    Text("Convenience fee")
                                    Spacer()
                                    Text("₹\(Int(booking.convenienceFee))")
                                }
                                Divider()
                                HStack {
                                    Text("Total paid")
                                        .font(.headline)
                                    Spacer()
                                    Text("₹\(Int(booking.totalAmount))")
                                        .font(.headline)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Ticket Details")
            } else {
                Text("No booking information.")
            }
        }
    }
}
