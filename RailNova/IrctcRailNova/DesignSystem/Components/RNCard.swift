import SwiftUI

// MARK: - Base Card

struct RNCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 16
    
    init(padding: CGFloat = 16, cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(Color.railNovaCardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Train Result Card

struct TrainResultCard: View {
    let train: Train
    var selectedClass: TrainClass?
    let onClassTap: (TrainClassAvailability) -> Void
    let onBookTap: () -> Void
    
    var body: some View {
        RNCard {
            VStack(alignment: .leading, spacing: 12) {
                // Train Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(train.number ?? "TNumber")
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.railNovaTextSecondary)
                        Text(train.name ??  "TName")
                            .font(RNTypography.headlineSmall)
                            .foregroundColor(.railNovaTextPrimary)
                    }
                    Spacer()
                    Image(systemName: "heart")
                        .foregroundColor(.railNovaTextMuted)
                }
                
                // Journey Info
                HStack {
                    VStack(alignment: .leading) {
                        Text(train.departureTime ?? "TDepTime")
                            .font(RNTypography.trainTime)
                            .foregroundColor(.railNovaTextPrimary)
                        Text(train.from ?? "TFrom")
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.railNovaTextSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("\(train.durationMinutes)")
                            .font(RNTypography.bodySmall)
                            .foregroundColor(.railNovaTextMuted)
                        Rectangle()
                            .fill(Color.railNovaTextMuted)
                            .frame(height: 1)
                            .overlay(alignment: .center) {
                                Image(systemName: "train.side.front.car")
                                    .font(.caption)
                                    .foregroundColor(.railNovaSecondary)
                                    .background(Color.railNovaCardBackground)
                                    .padding(.horizontal, 4)
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(train.arrivalTime ?? "TArrival")
                            .font(RNTypography.trainTime)
                            .foregroundColor(.railNovaTextPrimary)
                        Text(train.to ?? "TCode")
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.railNovaTextSecondary)
                    }
                }
                
                // Class Availability
                let classes = train.classes
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(classes) { trainClass in
                            let status = AvailabilityStatus(
                                fromAvailableSeats: trainClass.available
                            )
                            AvailabilityBadge(
                                travelClass: trainClass.code,
                                status: status,
                                fare: Double(trainClass.fare),
                                isSelected: selectedClass?.id == trainClass.id
                            ) {
                                onClassTap(trainClass)
                            }
                        }
                    }
                }
            }
        }
    }
}
