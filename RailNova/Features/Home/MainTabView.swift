import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    
    @State private var selectedTab: Tab = .home
    
    enum Tab: Int {
        case home, search, bookings, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == .home ? "house.fill" : "house")
                }
                .tag(Tab.home)
            
            TrainSearchView()
                .tabItem {
                    Label("Search", systemImage: selectedTab == .search ? "magnifyingglass.circle.fill" : "magnifyingglass")
                }
                .tag(Tab.search)
            
            MyBookingsView()
                .tabItem {
                    Label("My Bookings", systemImage: selectedTab == .bookings ? "ticket.fill" : "ticket")
                }
                .tag(Tab.bookings)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == .profile ? "person.fill" : "person")
                }
                .tag(Tab.profile)
        }
        .tint(Color.rnSecondary)
    }
}
