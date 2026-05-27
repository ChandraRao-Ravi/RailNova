//
//  MainTabView.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 26/05/26.
//

import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack { HomeView() }
            }
            Tab("Search", systemImage: "magnifyingglass") {
                NavigationStack { TrainSearchView() }
            }
            Tab("Bookings", systemImage: "ticket") {
                NavigationStack { MyBookingsView() }
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                NavigationStack { ProfileView() }
            }
        }
        .tint(.railNovaSecondary) // your accent color
        .tabBarMinimizeBehavior(.never)
    }
}
