import SwiftUI
import Combine

// MARK: - Train Search ViewModel

@MainActor
final class TrainSearchViewModel: ObservableObject {
    
    @Published var fromStation: Station?
    @Published var toStation: Station?
    @Published var journeyDate = Date()
    @Published var selectedClass: TravelClass = .sleeperClass
    @Published var selectedQuota: Quota = .general
    @Published var isFlexibleDate = false
    
    @Published var searchResults: [Train] = []
    @Published var isSearching = false
    @Published var errorMessage: String?
    
    @Published var stationSuggestions: [Station] = []
    @Published var isSearchingStations = false
    
    // Filters
    @Published var filterDepartureRange: ClosedRange<Double> = 0...24
    @Published var filterArrivalRange: ClosedRange<Double> = 0...24
    @Published var selectedTrainTypes: Set<String> = []
    
    private let trainService = TrainService.shared
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Search Trains
    func searchTrains() async {
        guard let from = fromStation, let to = toStation else {
            errorMessage = "Please select From and To stations"
            return
        }
        isSearching = true
        errorMessage = nil
        searchTask?.cancel()
        
        // TEMP: use mock data instead of real API
//        await Task.sleep(300_000_000) // 0.3s fake delay
//        
//        // Basic route-based mock
//        if from.code == "NDLS" && (to.code == "BCT" || to.code == "CSMT") {
//            searchResults = MockData.ndlsToMumbaiTrains
//        } else if from.code == "LKO" && to.code == "CNB" {
//            searchResults = MockData.lkoToCnbTrains
//        } else {
//            searchResults = []
//            errorMessage = "No trains found for this route yet."
//        }
        
        // Later: replace above with real API call:
        
        searchTask = Task {
            do {
                let request = TrainSearchRequest(
                    fromStation: from,
                    toStation: to,
                    journeyDate: journeyDate,
                    travelClass: selectedClass,
                    quota: selectedQuota,
                    isFlexibleDate: isFlexibleDate
                )
                searchResults = try await trainService.searchTrains(request: request)
                print("\(searchResults.first?.name)")
                print("\(searchResults.first?.number)")
            } catch {
                if !Task.isCancelled {
                    errorMessage = error.localizedDescription
                    print("error: \(errorMessage)")
                }
            }
        }
        isSearching = false
    }
    
    func swapStations() {
        let temp = fromStation
        fromStation = toStation
        toStation = temp
    }
    
    var canSearch: Bool {
        fromStation != nil && toStation != nil && fromStation?.id != toStation?.id
    }
}
