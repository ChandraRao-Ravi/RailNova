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
            .background(Color.rnCardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Train Result Card

struct TrainResultCard: View {
    let train: Train
    var selectedClass: TrainClass?
    let onClassTap: (TrainClass) -> Void
    let onBookTap: () -> Void
    
    var body: some View {
        RNCard {
            VStack(alignment: .leading, spacing: 12) {
                // Train Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(train.number)
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.rnTextSecondary)
                        Text(train.name)
                            .font(RNTypography.headlineSmall)
                            .foregroundColor(.rnTextPrimary)
                    }
                    Spacer()
                    Image(systemName: "heart")
                        .foregroundColor(.rnTextMuted)
                }
                
                // Journey Info
                HStack {
                    VStack(alignment: .leading) {
                        Text(train.departureTime)
                            .font(RNTypography.trainTime)
                            .foregroundColor(.rnTextPrimary)
                        Text(train.fromStation.code)
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.rnTextSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text(train.duration)
                            .font(RNTypography.bodySmall)
                            .foregroundColor(.rnTextMuted)
                        Rectangle()
                            .fill(Color.rnTextMuted)
                            .frame(height: 1)
                            .overlay(alignment: .center) {
                                Image(systemName: "train.side.front.car")
                                    .font(.caption)
                                    .foregroundColor(.rnSecondary)
                                    .background(Color.rnCardBackground)
                                    .padding(.horizontal, 4)
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(train.arrivalTime)
                            .font(RNTypography.trainTime)
                            .foregroundColor(.rnTextPrimary)
                        Text(train.toStation.code)
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.rnTextSecondary)
                    }
                }
                
                // Class Availability
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(train.classes) { trainClass in
                            AvailabilityBadge(
                                travelClass: trainClass.type,
                                status: trainClass.availability,
                                fare: trainClass.fare,
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
