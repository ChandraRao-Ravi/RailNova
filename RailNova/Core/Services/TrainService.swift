import Foundation
import Combine

// MARK: - Train Service

final class TrainService {
    
    static let shared = TrainService()
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func searchTrains(request: TrainSearchRequest) async throws -> [Train] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: request.journeyDate)
        
        let endpoint = TrainEndpoint.searchTrains(
            from: request.fromStation.code,
            to: request.toStation.code,
            date: dateString,
            travelClass: request.travelClass.rawValue,
            quota: request.quota.rawValue
        )
        return try await apiClient.request(endpoint: endpoint, responseType: [Train].self)
    }
    
    func getCoachLayout(trainNumber: String, coachType: TravelClass, date: Date) async throws -> CoachLayout {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let endpoint = TrainEndpoint.coachLayout(
            trainNumber: trainNumber,
            coachType: coachType.rawValue,
            date: formatter.string(from: date)
        )
        return try await apiClient.request(endpoint: endpoint, responseType: CoachLayout.self)
    }
    
    func getLiveStatus(trainNumber: String) async throws -> LiveTrainStatus {
        let endpoint = TrainEndpoint.liveStatus(trainNumber: trainNumber)
        return try await apiClient.request(endpoint: endpoint, responseType: LiveTrainStatus.self)
    }
    
    func searchStations(query: String) async throws -> [Station] {
        let endpoint = TrainEndpoint.stationSearch(query: query)
        return try await apiClient.request(endpoint: endpoint, responseType: [Station].self)
    }
    
    func getPNRStatus(pnr: String) async throws -> PNRStatus {
        let endpoint = BookingEndpoint.pnrStatus(pnr: pnr)
        return try await apiClient.request(endpoint: endpoint, responseType: PNRStatus.self)
    }
}
