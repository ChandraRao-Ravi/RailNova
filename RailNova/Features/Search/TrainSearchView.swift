import SwiftUI

// MARK: - Train Search View (Stub)

struct TrainSearchView: View {
    @StateObject private var viewModel = TrainSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Search Trains")
                    .font(RNTypography.headlineLarge)
                // TODO: Full implementation in Phase 2
                // - Station autocomplete search
                // - Date picker with horizontal scroll
                // - Class & Quota selectors
                // - Search button → TrainResultsView
            }
            .navigationTitle("Search")
        }
    }
}
