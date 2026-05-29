//
//  MainTabView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 26/05/26.
//

import SwiftUI

enum MainTab {
    case home
    case search
    case bookings
    case profile
}

// MARK: - Main Tab View

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(MainTab.home)

            NavigationStack {
                TrainSearchView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(MainTab.search)

            NavigationStack {
                MyBookingsView(authVM: authVM)
            }
            .tabItem {
                Label("Bookings", systemImage: "ticket")
            }
            .tag(MainTab.bookings)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .tag(MainTab.profile)
        }
        .tint(.railNovaSecondary)
        .tabBarMinimizeBehavior(.never)
    }
}
