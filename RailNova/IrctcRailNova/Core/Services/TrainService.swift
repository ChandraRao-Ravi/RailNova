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
        let response = try await apiClient.request(
            endpoint: endpoint,
            responseType: TrainSearchResponse.self
        )
        return response.trains
    }
}
