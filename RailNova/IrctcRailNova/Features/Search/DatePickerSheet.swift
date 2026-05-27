//
//  DatePickerSheet.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI

struct DatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
    }

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Journey Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()

                Spacer()
            }
            .navigationTitle("Select Date")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
