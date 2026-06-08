import SwiftUI

// MARK: - Profile View (Stub)

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    let menuItems: [(icon: String, title: String, subtitle: String, color: Color)] = [
        ("person.2.fill", "Passenger List", "Manage saved passengers", .blue),
        ("creditcard.fill", "Saved Payment Methods", "Manage cards and UPI", .green),
        ("slider.horizontal.3", "Travel Preferences", "Set your travel preferences", .orange),
        ("questionmark.circle.fill", "Help & Support", "Get help and contact support", .purple),
        ("gearshape.fill", "Settings", "Manage app settings", .gray),
    ]
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Header
                Section {
                    HStack(spacing: 16) {
                        
                        // avatar
                        if let url = authManager.currentUser?.fullName as? URL {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.railNovaSecondary)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text(
                                        String(
                                            authManager.currentUser?.fullName?
                                                .prefix(1) ?? "A"
                                        )
                                    )
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if let user = authManager.currentUser?.fullName {
                                Text(user)
                                    .font(RNTypography.headlineSmall)
                            } else {
                                Text("Hi, there")
                                    .font(RNTypography.headlineSmall)
                            }
                            if let email = authManager.currentUser?.email {
                                Text(email)
                                    .font(RNTypography.bodySmall)
                                    .foregroundColor(.railNovaTextSecondary)
                            } else {
                                Text("xxx@xxx.com")
                                    .font(RNTypography.bodySmall)
                                    .foregroundColor(.railNovaTextSecondary)
                            }
                            Text("+91 XXXXX XXXXX")
                                .font(RNTypography.bodySmall)
                                .foregroundColor(.railNovaTextSecondary)
                        }
                        Spacer()
                        Button("Edit") { }
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.railNovaSecondary)
                    }
                    .padding(.vertical, 8)
                }
                
                // Menu Items
                Section {
                    ForEach(menuItems, id: \.title) { item in
                        NavigationLink {
                            Text(item.title)
                        } label: {
                            Label {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title).font(RNTypography.bodyMedium)
                                    Text(item.subtitle).font(RNTypography.bodySmall).foregroundColor(.railNovaTextMuted)
                                }
                            } icon: {
                                Image(systemName: item.icon)
                                    .foregroundColor(item.color)
                            }
                        }
                    }
                }
                
                // Logout
                Section {
                    Button(role: .destructive) {
                        authManager.logout()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
