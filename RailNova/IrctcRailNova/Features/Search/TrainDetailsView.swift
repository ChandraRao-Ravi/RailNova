//
//  TrainDetailsView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI

struct TrainDetailsView: View {
    let train: Train
    let journeyDate: Date
    let travelClassFromSearch: TravelClass?
    let quota: Quota
    let fromStation: Station
    let toStation: Station

    @State private var selectedClass: TrainClassAvailability?
    @Binding var selectedTab: MainTab

    init(
        train: Train,
        journeyDate: Date,
        selectedClass: TrainClassAvailability? = nil,
        quota: Quota,
        travelClassFromSearch: TravelClass? = nil,
        fromStation: Station,
        toStation: Station,
        selectedTab: Binding<MainTab>
    ) {
        self.train = train
        self.journeyDate = journeyDate
        self.quota = quota
        self.travelClassFromSearch = travelClassFromSearch
        self.fromStation = fromStation
        self.toStation = toStation
        self._selectedTab = selectedTab
        self._selectedClass = State(initialValue: selectedClass)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // Header card: train name, number, route, timings
                RNCard {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(train.number ?? "TNumber")
                                    .font(RNTypography.labelMedium)
                                    .foregroundColor(.railNovaTextSecondary)
                                Text(train.name ?? "TName")
                                    .font(RNTypography.headlineSmall)
                                    .foregroundColor(.railNovaTextPrimary)
                            }
                            Spacer()
                            // days of run
                            let dayLabels = ["M","T","W","T","F","Sa","S"]

                            HStack(spacing: 4) {
                                ForEach(dayLabels, id: \.self) { label in
                                    let runs: Bool = {
                                        // Normalize daysOfOperation to an array of Strings if available
                                        if let days = train.daysOfOperation as? [String] {
                                            // If daysOfOperation is a String of characters (e.g., "MTWTFSS"), check characters
                                            if let daysString = days as? String {
                                                return daysString.contains(Character(label))
                                            }
                                            // If it's already a collection of Strings, check membership
                                            if let daysArray = days as? [String] {
                                                return daysArray.contains(label)
                                            }
                                        }
                                        return false
                                    }()

                                    Text(label)
                                        .font(RNTypography.labelSmall)
                                        .foregroundColor(runs ? .railNovaSecondary : .railNovaTextMuted)
                                }
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(train.departureTime ?? "TDeparture")
                                    .font(RNTypography.trainTime)
                                Text(train.number ?? "TNumber")
                                    .font(RNTypography.labelMedium)
                                Text(train.from ?? "TName")
                                    .font(RNTypography.bodySmall)
                                    .foregroundColor(.railNovaTextSecondary)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text("\(train.durationMinutes)")
                                    .font(RNTypography.bodySmall)
                                    .foregroundColor(.railNovaTextMuted)
                                Rectangle()
                                    .fill(Color.railNovaTextMuted.opacity(0.4))
                                    .frame(height: 1)
                                    .overlay(
                                        Image(systemName: "train.side.front.car")
                                            .font(.caption)
                                            .foregroundColor(.railNovaSecondary)
                                    )
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(train.arrivalTime ?? "TArrival")
                                    .font(RNTypography.trainTime)
                                Text(train.number ?? "TNumber")
                                    .font(RNTypography.labelMedium)
                                Text(train.to ?? "TName")
                                    .font(RNTypography.bodySmall)
                                    .foregroundColor(.railNovaTextSecondary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Class availability chips
                // Assuming `train.classes` is [TrainClassAvailability]
                let classes = train.classes

                RNCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Classes & availability")
                            .font(RNTypography.bodyMedium)
                            .foregroundColor(.railNovaTextSecondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(classes) { trainClass in
                                    let status = AvailabilityStatus(fromAvailableSeats: trainClass.available)
                                    AvailabilityBadge(
                                        travelClass: trainClass.code,
                                        status: status,           // was availability
                                        fare: Double(trainClass.fare),          // convert Int -> Double
                                        isSelected: selectedClass?.id == trainClass.id
                                    ) {
                                        // will fix this in next section
                                        selectedClass = trainClass
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 16)
            }
            .padding(.top, 16)
        }
        .background(Color.railNovaBackground.ignoresSafeArea())
        .navigationTitle("Train Details")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            if let selectedClass {
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedClass.code.displayName)
                                .font(RNTypography.bodyMedium)
                            let status = AvailabilityStatus(fromAvailableSeats: selectedClass.available)
                            Text(status.displayText)
                                .font(RNTypography.labelSmall)
                                .foregroundColor(.railNovaTextSecondary)
                        }
                        Spacer()
                        Text("₹ \(Int(selectedClass.fare))")
                            .font(RNTypography.fareDisplay)
                            .foregroundColor(.railNovaTextPrimary)
                    }
                    
                    NavigationLink {
                        PassengerDetailsView(
                            train: train,
                            journeyDate: journeyDate,
                            travelClass: selectedClass.code,
                            quota: quota,
                            initialPassengerCount: 1, // optional, default is 1
                            fromStation: fromStation,
                            toStation: toStation,
                            selectedTab: $selectedTab
                        )
                    } label: {
                        HStack {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Continue")
                                .font(RNTypography.labelLarge)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.railNovaSecondary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(.ultraThinMaterial)
            }
        }
    }
}

