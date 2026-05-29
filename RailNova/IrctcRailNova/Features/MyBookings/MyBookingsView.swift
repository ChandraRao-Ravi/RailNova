import SwiftUI

// MARK: - My Bookings View (Stub)

struct MyBookingsView: View {
    @State private var selectedTab = 0
    let tabs = ["Upcoming", "Completed", "Cancelled"]
    @StateObject private var vm: MyBookingsViewModel
    
    init(
        authVM: AuthViewModel
    ) {
        _vm = StateObject(wrappedValue: MyBookingsViewModel(authVM: authVM))
    }

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
                        .foregroundColor(selectedTab == index ? .railNovaSecondary : .railNovaTextMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(alignment: .bottom) {
                            if selectedTab == index {
                                Rectangle()
                                    .fill(Color.railNovaSecondary)
                                    .frame(height: 2)
                            }
                        }
                    }
                }
                .background(Color.railNovaSurface)
                
                // TODO: Booking list with filters in Phase 3
                Spacer()
                Text("Your bookings will appear here")
                    .foregroundColor(.railNovaTextMuted)
                Spacer()
            }
            .onAppear {
                Task {
                    await vm.loadBookings()                    
                }
            }
            .navigationTitle("My Bookings")
            .background(Color.railNovaBackground)
        }
    }
}
