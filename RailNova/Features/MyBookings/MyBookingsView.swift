import SwiftUI

// MARK: - My Bookings View (Stub)

struct MyBookingsView: View {
    @State private var selectedTab = 0
    let tabs = ["Upcoming", "Completed", "Cancelled"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Tabs
                HStack(spacing: 0) {
                    ForEach(tabs.indices, id: \.self) { index in
                        Button(tabs[index]) {
                            selectedTab = index
                        }
                        .font(RNTypography.labelLarge)
                        .foregroundColor(selectedTab == index ? .rnSecondary : .rnTextMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(alignment: .bottom) {
                            if selectedTab == index {
                                Rectangle()
                                    .fill(Color.rnSecondary)
                                    .frame(height: 2)
                            }
                        }
                    }
                }
                .background(Color.rnSurface)
                
                // TODO: Booking list with filters in Phase 3
                Spacer()
                Text("Your bookings will appear here")
                    .foregroundColor(.rnTextMuted)
                Spacer()
            }
            .navigationTitle("My Bookings")
            .background(Color.rnBackground)
        }
    }
}
