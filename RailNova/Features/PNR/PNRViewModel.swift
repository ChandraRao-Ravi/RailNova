import SwiftUI

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
    
    func checkPNRStatus() async {
        guard pnrInput.count == 10 else {
            errorMessage = "PNR must be 10 digits"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            pnrStatus = try await trainService.getPNRStatus(pnr: pnrInput)
            saveToRecent(pnr: pnrInput)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
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
