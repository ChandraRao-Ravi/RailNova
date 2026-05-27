import SwiftUI
import Combine

// MARK: - PNR ViewModel

@MainActor
final class PNRViewModel: ObservableObject {
    
    @Published var pnrInput = ""
    @Published var pnrStatus: PNRStatus?
    @Published var recentPNRs: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let trainService = TrainService.shared
    private let maxRecentPNRs = 5
    
    init() {
        recentPNRs = UserDefaults.standard.stringArray(forKey: "recentPNRs") ?? []
    }
    
    private func saveToRecent(pnr: String) {
        recentPNRs.removeAll { $0 == pnr }
        recentPNRs.insert(pnr, at: 0)
        if recentPNRs.count > maxRecentPNRs {
            recentPNRs = Array(recentPNRs.prefix(maxRecentPNRs))
        }
        UserDefaults.standard.set(recentPNRs, forKey: "recentPNRs")
    }
    
    func selectRecent(_ pnr: String) {
        pnrInput = pnr
    }
    
    func clearResults() {
        pnrStatus = nil
        pnrInput = ""
    }
}
