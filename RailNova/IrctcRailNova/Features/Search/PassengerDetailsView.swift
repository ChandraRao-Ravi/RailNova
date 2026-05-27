//
//  PassengerDetailsView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import SwiftUI

struct PassengerDetailsView: View {
    let train: Train
    let journeyDate: Date
    let travelClass: TravelClass
    let quota: Quota

    @State private var passengers: [Passenger]
    @State private var contactEmail: String = ""
    @State private var contactPhone: String = ""
    @State private var showValidationError = false
    @State private var navigateToReview = false

    @State private var invalidPassengerIndices: Set<Int> = []
    @State private var isContactEmailInvalid = false
    @State private var isContactPhoneInvalid = false

    init(
        train: Train,
        journeyDate: Date,
        travelClass: TravelClass,
        quota: Quota,
        initialPassengerCount: Int = 1
    ) {
        self.train = train
        self.journeyDate = journeyDate
        self.travelClass = travelClass
        self.quota = quota

        let count = max(1, min(initialPassengerCount, 6)) // clamp 1…6
        _passengers = State(initialValue: (0..<count).map { _ in
            Passenger(
                id: UUID().uuidString,
                name: "",
                age: 25,
                gender: .male,
                berthPreference: .noPreference,
                isInfant: false,
                requiresBerth: true
            )
        })
    }

    var body: some View {
        Form {
            // Journey summary
            Section(header: Text("Journey")) {
                Text("\(train.name) (\(train.number))")
                Text(journeyDate, style: .date)
                Text("\(travelClass.displayName) • \(quota.displayName)")
            }

            // Passengers
            Section(
                header: Text("Passengers"),
                footer: Text("You can add up to 6 passengers per ticket, swipe the passenger card to remove a passenger.")
            ) {
                ForEach(passengers.indices, id: \.self) { index in
                    passengerRow(index: index)
                }
                .onDelete(perform: deletePassengers)

                Button {
                    addPassenger()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Passenger")
                    }
                }
                .disabled(passengers.count >= 6)
            }

            // Contact Details
            Section(header: Text("Contact details")) {
                // Email
                VStack(alignment: .leading, spacing: 4) {
                    if isContactEmailInvalid {
                        // Grey label, no TextField (matches Full name + error)
                        Text("Email")
                            .foregroundColor(.secondary)

                        Text("Enter your email")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        // Normal editable field
                        TextField("Email", text: $contactEmail)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                    }
                }

                // Mobile
                VStack(alignment: .leading, spacing: 4) {
                    if isContactPhoneInvalid {
                        Text("Mobile number")
                            .foregroundColor(.secondary)

                        Text("Enter mobile number")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        TextField("Mobile number", text: $contactPhone)
                            .keyboardType(.phonePad)
                    }
                }
            }
        }
        .navigationTitle("Passenger Details")
        // Hidden navigation link controlled by state
        .background(
            NavigationLink(
                destination: ReviewBookingView(
                    train: train,
                    journeyDate: journeyDate,
                    travelClass: travelClass,
                    quota: quota,
                    passengers: passengers,
                    contactEmail: contactEmail,
                    contactPhone: contactPhone
                ),
                isActive: $navigateToReview
            ) {
                EmptyView()
            }
            .hidden()
        )
        // Bottom inset CTA, full width, aligned with cards
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button(action: {
                    if isValid() {
                        navigateToReview = true
                    } else {
                        showValidationError = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Review Journey")
                            .font(RNTypography.labelLarge)
                        Spacer()
                    }
                    .frame(height: 52)
                    .background(Color.railNovaSecondary)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .background(.ultraThinMaterial)
        }
    }

    // MARK: - Row for a single passenger

    @ViewBuilder
    private func passengerRow(index: Int) -> some View {
        let passengerNumber = index + 1
        let title = "Passenger \(passengerNumber)"

        let ageBinding = Binding<Int>(
            get: { passengers[index].age },
            set: { passengers[index].age = $0 }
        )

        let ageText = "Age: \(passengers[index].age)"

        let genderBinding = Binding<Gender>(
            get: { passengers[index].gender },
            set: { passengers[index].gender = $0 }
        )

        let genders = Gender.allCases

        let berthBinding = Binding<BerthType>(
            get: { passengers[index].berthPreference },
            set: { passengers[index].berthPreference = $0 }
        )

        let berthOptions = BerthType.allCases

        let hasError = invalidPassengerIndices.contains(index)

        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            TextField("Full name", text: $passengers[index].name)
                .textInputAutocapitalization(.words)

            if hasError && passengers[index].name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Enter passenger name")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Stepper(value: ageBinding, in: 1...120) {
                Text(ageText)
            }

            if hasError && passengers[index].age <= 0 {
                Text("Enter a valid age")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Picker("Gender", selection: genderBinding) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender.rawValue)
                        .tag(gender as Gender)
                }
            }

            Picker("Berth preference", selection: berthBinding) {
                ForEach(berthOptions, id: \.self) { berth in
                    Text(berth.displayName)
                        .tag(berth as BerthType)
                }
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Actions

    private func addPassenger() {
        guard passengers.count < 6 else { return }
        passengers.append(
            Passenger(
                id: UUID().uuidString,
                name: "",
                age: 25,
                gender: .male,
                berthPreference: .noPreference,
                isInfant: false,
                requiresBerth: true
            )
        )
    }

    private func deletePassengers(at offsets: IndexSet) {
        guard passengers.count > 1 else { return } // keep at least one
        passengers.remove(atOffsets: offsets)
    }

    // MARK: - Validation

    private func isValid() -> Bool {
        invalidPassengerIndices.removeAll()
        isContactEmailInvalid = false
        isContactPhoneInvalid = false

        // Contact validation
        if contactEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isContactEmailInvalid = true
        }
        if contactPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isContactPhoneInvalid = true
        }

        // Passenger validation
        for (index, p) in passengers.enumerated() {
            if p.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || p.age <= 0 {
                invalidPassengerIndices.insert(index)
            }
        }

        return invalidPassengerIndices.isEmpty && !isContactEmailInvalid && !isContactPhoneInvalid
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
