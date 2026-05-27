import Foundation

// MARK: - Live Train Status Models

struct LiveTrainStatus: Identifiable, Codable {
    let id: String
    let trainNumber: String
    let trainName: String
    let runningStatus: RunningStatus
    let currentSpeed: Int         // km/h
    let lastUpdated: Date
    let stations: [StationStatus]
    let currentStationIndex: Int  // index of last departed station
}

struct StationStatus: Identifiable, Codable {
    let id: String
    let station: Station
    let scheduledArrival: String
    let scheduledDeparture: String
    let actualArrival: String?
    let actualDeparture: String?
    let delayMinutes: Int
    let status: StationArrivalStatus
    let platform: Int?
    let distanceFromOrigin: Int  // in km
}

enum RunningStatus: String, Codable {
    case onTime = "On Time"
    case lateByMinutes = "Slightly Late"
    case lateByHour = "Late"
    case veryLate = "Very Late"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .onTime: return "green"
        case .lateByMinutes: return "yellow"
        case .lateByHour: return "orange"
        case .veryLate, .cancelled: return "red"
        }
    }
}

enum StationArrivalStatus: String, Codable {
    case departed = "Departed"
    case arrived = "Arrived"
    case upcoming = "Upcoming"
    case origin = "Origin"
    case destination = "Destination"
}
