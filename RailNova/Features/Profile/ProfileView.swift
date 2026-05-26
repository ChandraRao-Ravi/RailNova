import SwiftUI

// MARK: - Profile View (Stub)

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
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
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.rnSecondary)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Aarav Sharma")
                                .font(RNTypography.headlineSmall)
                            Text("aarav.sharma@gmail.com")
                                .font(RNTypography.bodySmall)
                                .foregroundColor(.rnTextSecondary)
                            Text("+91 98765 43210")
                                .font(RNTypography.bodySmall)
                                .foregroundColor(.rnTextSecondary)
                        }
                        Spacer()
                        Button("Edit") { }
                            .font(RNTypography.labelMedium)
                            .foregroundColor(.rnSecondary)
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
                                    Text(item.subtitle).font(RNTypography.bodySmall).foregroundColor(.rnTextMuted)
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
                        authVM.signOut()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
