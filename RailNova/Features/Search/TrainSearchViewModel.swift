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
            } catch {
                if !Task.isCancelled {
                    errorMessage = error.localizedDescription
                }
            }
            isSearching = false
        }
    }
    
    // MARK: - Station Autocomplete
    func searchStations(query: String) async {
        guard query.count >= 2 else { stationSuggestions = []; return }
        isSearchingStations = true
        do {
            stationSuggestions = try await trainService.searchStations(query: query)
        } catch {
            stationSuggestions = []
        }
        isSearchingStations = false
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
