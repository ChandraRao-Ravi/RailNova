//
//  StationPickerView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI

struct StationPickerView: View {
    let title: String
    let onSelect: (Station) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    init(title: String, onSelect: @escaping (Station) -> Void) {
        self.title = title
        self.onSelect = onSelect
    }

    // Temporary mocked stations
    var allStations: [Station] = [
        Station(id: "NDLS", code: "NDLS", name: "New Delhi", city: "Delhi"),
        Station(id: "BCT", code: "BCT", name: "Mumbai Central", city: "Mumbai"),
        Station(id: "CSMT", code: "CSMT", name: "Mumbai CSMT", city: "Mumbai"),
        Station(id: "LKO", code: "LKO", name: "Lucknow Junction", city: "Lucknow"),
        Station(id: "CNB", code: "CNB", name: "Kanpur Central", city: "Kanpur")
    ]

    var filteredStations: [Station] {
        guard !searchText.isEmpty else { return allStations }
        return allStations.filter {
            $0.code.lowercased().contains(searchText.lowercased()) ||
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.city.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredStations) { station in
                Button {
                    onSelect(station)
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text("\(station.name) (\(station.code))")
                        Text(station.city)
                            .font(RNTypography.bodySmall)
                            .foregroundColor(.railNovaTextMuted)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search station")
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
