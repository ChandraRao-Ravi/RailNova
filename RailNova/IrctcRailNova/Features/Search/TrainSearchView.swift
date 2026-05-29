//
//  TrainSearchView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI

struct TrainSearchView: View {
    @Binding var selectedTab: MainTab

    @StateObject private var viewModel = TrainSearchViewModel()
    @State private var isShowingFromStationSheet = false
    @State private var isShowingToStationSheet = false
    @State private var isShowingDatePicker = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // From / To + Swap
                    RNCard {
                        VStack(spacing: 14) {
                            HStack(spacing: 12) {
                                RNStationField(
                                    label: "From",
                                    placeholder: "Source station",
                                    station: $viewModel.fromStation
                                ) {
                                    isShowingFromStationSheet = true
                                }
                                
                                Button {
                                    viewModel.swapStations()
                                } label: {
                                    Image(systemName: "arrow.left.arrow.right")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.railNovaSecondary)
                                        .padding(8)
                                        .background(Color.railNovaSurface)
                                        .cornerRadius(10)
                                }
                                
                                RNStationField(
                                    label: "To",
                                    placeholder: "Destination station",
                                    station: $viewModel.toStation
                                ) {
                                    isShowingToStationSheet = true
                                }
                            }
                            
                            // Date + Class + Quota
                            VStack(spacing: 12) {
                                // Date row
                                Button {
                                    isShowingDatePicker = true
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Journey Date")
                                                .font(RNTypography.labelSmall)
                                                .foregroundColor(.railNovaTextMuted)
                                            Text(viewModel.journeyDate, style: .date)
                                                .font(RNTypography.bodyLarge)
                                                .foregroundColor(.railNovaTextPrimary)
                                        }
                                        Spacer()
                                        Image(systemName: "calendar")
                                            .foregroundColor(.railNovaSecondary)
                                    }
                                    .padding(12)
                                    .background(Color.railNovaSurface)
                                    .cornerRadius(10)
                                }
                                
                                // Class + Quota row
                                HStack(spacing: 12) {
                                    Menu {
                                        ForEach(TravelClass.allCases, id: \.self) { item in
                                            Button(item.displayName) {
                                                viewModel.selectedClass = item
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(viewModel.selectedClass.displayName)
                                                .font(RNTypography.bodyMedium)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                        }
                                        .padding(12)
                                        .background(Color.railNovaSurface)
                                        .cornerRadius(10)
                                    }
                                    
                                    Menu {
                                        ForEach(Quota.allCases, id: \.self) { quota in
                                            Button(quota.displayName) {
                                                viewModel.selectedQuota = quota
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(viewModel.selectedQuota.displayName)
                                                .font(RNTypography.bodyMedium)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                        }
                                        .padding(12)
                                        .background(Color.railNovaSurface)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Flexible with date + PWD/Pass later (IRCTC style) [file:4]
                    
                    // Search button
                    RNPrimaryButton(
                        "Search Trains",
                        icon: "magnifyingglass",
                        isDisabled: !viewModel.canSearch
                    ) {
                        Task { await viewModel.searchTrains() }
                    }
                    .padding(.horizontal)
                    
                    // Results
                    if viewModel.isSearching {
                        ProgressView("Searching trains...")
                            .padding()
                    } else if !viewModel.searchResults.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.searchResults) { train in
                                NavigationLink {
                                    TrainDetailsView(
                                        train: train,
                                        journeyDate: viewModel.journeyDate,
                                        selectedClass: nil,
                                        quota: viewModel.selectedQuota,
                                        travelClassFromSearch: viewModel.selectedClass,
                                        fromStation: viewModel.fromStation ?? StationDirectory
                                            .station(for: ""),
                                        toStation: viewModel.toStation ?? StationDirectory
                                            .station(for: ""),
                                        selectedTab: $selectedTab
                                    )
                                } label: {
                                    TrainResultCard(
                                        train: train,
                                        selectedClass: nil,
                                        onClassTap: { _ in },
                                        onBookTap: { }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
                .padding(.top, 16)
            }
            .background(Color.railNovaBackground.ignoresSafeArea())
            .navigationTitle("Search Trains")
        }
        .sheet(isPresented: $isShowingFromStationSheet) {
            StationPickerView(
                title: "From station",
                onSelect: { viewModel.fromStation = $0 }
            )
        }
        .sheet(isPresented: $isShowingToStationSheet) {
            StationPickerView(
                title: "To station",
                onSelect: { viewModel.toStation = $0 }
            )
        }
        .sheet(isPresented: $isShowingDatePicker) {
            DatePickerSheet(selectedDate: $viewModel.journeyDate)
        }
    }
}
