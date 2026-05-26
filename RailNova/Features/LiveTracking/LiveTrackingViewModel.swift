import SwiftUI
import Combine

// MARK: - Live Tracking ViewModel

@MainActor
final class LiveTrackingViewModel: ObservableObject {
    
    @Published var trainNumberInput = ""
    @Published var liveStatus: LiveTrainStatus?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastRefreshed: Date?
    
    private let trainService = TrainService.shared
    private var refreshTimer: Timer?
    private let refreshInterval: TimeInterval = 30 // seconds
    
    func fetchLiveStatus(trainNumber: String? = nil) async {
        let number = trainNumber ?? trainNumberInput
        guard !number.isEmpty else { return }
        
        isLoading = liveStatus == nil  // Only show loader on first load
        errorMessage = nil
        
        do {
            liveStatus = try await trainService.getLiveStatus(trainNumber: number)
            lastRefreshed = Date()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { await self.fetchLiveStatus() }
        }
    }
    
    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    var currentStationName: String {
        guard let status = liveStatus,
              status.currentStationIndex < status.stations.count else { return "--" }
        return status.stations[status.currentStationIndex].station.name
    }
    
    var progressPercentage: Double {
        guard let status = liveStatus, status.stations.count > 1 else { return 0 }
        return Double(status.currentStationIndex) / Double(status.stations.count - 1)
    }
}
