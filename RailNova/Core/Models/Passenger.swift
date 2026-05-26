import Foundation

// MARK: - Passenger Models

struct Passenger: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var age: Int
    var gender: Gender
    var nationality: String = "India"
    var berthPreference: BerthType
    var isInfant: Bool = false
    var requiresBerth: Bool = true  // for infants
}

enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case transgender = "Transgender"
}

// MARK: - PNR Models

struct PNRStatus: Identifiable, Codable {
    let id: String
    let pnrNumber: String
    let train: Train
    let journeyDate: Date
    let fromStation: Station
    let toStation: Station
    let travelClass: TravelClass
    let quota: Quota
    let chartStatus: ChartStatus
    let passengerStatuses: [PNRPassengerStatus]
    let lastUpdated: Date
}

struct PNRPassengerStatus: Identifiable, Codable {
    let id: String
    let serialNumber: Int
    let bookingStatus: String   // e.g. "WL 12"
    let currentStatus: String  // e.g. "CNF B2/48"
    let coachNumber: String?
    let seatNumber: Int?
    let berthType: BerthType?
}
