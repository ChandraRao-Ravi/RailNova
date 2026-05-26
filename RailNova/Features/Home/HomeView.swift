import SwiftUI

// MARK: - Home View (Stub)

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var searchVM = TrainSearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hi, Aarav 👋")
                                .font(RNTypography.headlineLarge)
                            Text("Where do you want to go today?")
                                .font(RNTypography.bodyMedium)
                                .foregroundColor(.rnTextSecondary)
                        }
                        Spacer()
                        Button { } label: {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(.rnTextPrimary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick Search Card
                    RNCard {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                RNStationField(label: "From", placeholder: "New Delhi", station: $searchVM.fromStation) { }
                                Button { searchVM.swapStations() } label: {
                                    Image(systemName: "arrow.left.arrow.right")
                                        .foregroundColor(.rnSecondary)
                                }
                                RNStationField(label: "To", placeholder: "Mumbai CSMT", station: $searchVM.toStation) { }
                            }
                            RNPrimaryButton("Search Trains", icon: "magnifyingglass") {
                                Task { await searchVM.searchTrains() }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions Grid
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 16) {
                        QuickActionItem(icon: "ticket.fill", label: "Book\nTickets", color: .blue)
                        QuickActionItem(icon: "doc.text.magnifyingglass", label: "PNR\nStatus", color: .green)
                        QuickActionItem(icon: "train.side.front.car", label: "Live\nTrain", color: .orange)
                        QuickActionItem(icon: "list.bullet.rectangle", label: "My\nBookings", color: .purple)
                        QuickActionItem(icon: "xmark.circle", label: "Cancel\nTicket", color: .red)
                        QuickActionItem(icon: "fork.knife", label: "Food on\nTrain", color: .yellow)
                        QuickActionItem(icon: "brain.head.profile", label: "AI\nPrediction", color: .indigo)
                        QuickActionItem(icon: "ellipsis.circle", label: "More", color: .gray)
                    }
                    .padding(.horizontal)
                    
                    // AI Banner
                    RNCard(padding: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Get Confirm Ticket")
                                    .font(RNTypography.headlineSmall)
                                    .foregroundColor(.white)
                                Text("with AI Prediction")
                                    .font(RNTypography.bodyMedium)
                                    .foregroundColor(.white.opacity(0.8))
                                Button("Check Now") { }
                                    .font(RNTypography.labelMedium)
                                    .foregroundColor(.rnAccent)
                            }
                            Spacer()
                            Image(systemName: "brain")
                                .font(.system(size: 44))
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    .background(LinearGradient(colors: [.rnPrimary, .rnSecondary], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .background(Color.rnBackground)
            .navigationBarHidden(true)
        }
    }
}

struct QuickActionItem: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.12))
                    .frame(width: 56, height: 56)
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            Text(label)
                .font(RNTypography.labelSmall)
                .multilineTextAlignment(.center)
                .foregroundColor(.rnTextSecondary)
        }
    }
}
