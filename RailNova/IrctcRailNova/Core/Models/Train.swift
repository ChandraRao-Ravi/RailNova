import Foundation

// MARK: - Train Search Models

struct TrainSearchRequest {
    var fromStation: Station
    var toStation: Station
    var journeyDate: Date
    var travelClass: TravelClass
    var quota: Quota
    var isFlexibleDate: Bool = false
}

struct Station: Identifiable, Codable, Hashable {
    let id: String
    let code: String       // e.g. "NDLS"
    let name: String       // e.g. "New Delhi"
    let city: String
}

struct TrainSearchResponse: Decodable {
    let from: String
    let to: String
    let date: String
    let quota: String
    let trains: [Train]
}

struct Train: Identifiable, Codable {
    var id: String { "\(UUID())" }   // or a separate id if you prefer

    let number: String
    let name: String
    let from: String
    let to: String
    let departureTime: String
    let arrivalTime: String
    let durationMinutes: Int
    let daysOfOperation: [String]
    let classes: [TrainClassAvailability]
}

struct TrainClassAvailability: Identifiable, Codable {
    var id: String { "\(UUID())" }

    let code: TravelClass          // "1A", "2A", "3A", "SL"
    let name: String       // e.g. "First AC"
    let available: Int
    let fare: Int
}

struct TrainClass: Identifiable, Codable {
    var id: String { "\(UUID())" }
    let name: String?
    let code: TravelClass
    let availability: AvailabilityStatus
    let fare: Double?
    let cnfProbability: Int? // 0–100
}

// MARK: - Enums

enum TravelClass: String, Codable, CaseIterable {
    case firstAC = "1A"
    case secondAC = "2A"
    case thirdAC = "3A"
    case thirdACEconomy = "3E"
    case sleeperClass = "SL"
    case chairCar = "CC"
    case executiveChair = "EC"
    case secondSitting = "2S"
    
    var displayName: String {
        switch self {
        case .firstAC: return "First AC"
        case .secondAC: return "AC 2 Tier"
        case .thirdAC: return "AC 3 Tier"
        case .thirdACEconomy: return "AC 3 Economy"
        case .sleeperClass: return "Sleeper"
        case .chairCar: return "Chair Car"
        case .executiveChair: return "Executive Chair"
        case .secondSitting: return "Second Sitting"
        }
    }
}

enum Quota: String, Codable, CaseIterable {
    case general = "GN"
    case tatkal = "TQ"
    case premiumTatkal = "PT"
    case ladies = "LD"
    case divyaang = "HP"
    case railwayPass = "RP"
    
    var displayName: String {
        switch self {
        case .general: return "General"
        case .tatkal: return "Tatkal"
        case .premiumTatkal: return "Premium Tatkal"
        case .ladies: return "Ladies"
        case .divyaang: return "Divyaang"
        case .railwayPass: return "Railway Pass"
        }
    }
}

enum AvailabilityStatus: Codable {
    case available(Int)
    case waitlist(Int)
    case rac(Int)
    case notAvailable

    init(fromAvailableSeats seats: Int) {
        if seats > 0 {
            self = .available(seats)
        } else {
            self = .notAvailable
        }
    }

    var displayText: String {
        switch self {
        case .available(let count): return "AVL \(count)"
        case .waitlist(let num):    return "WL \(num)"
        case .rac(let num):         return "RAC \(num)"
        case .notAvailable:         return "N/A"
        }
    }

    var isBookable: Bool {
        switch self {
        case .available, .waitlist, .rac: return true
        case .notAvailable:              return false
        }
    }
}

enum SeatStatus: String, Codable {
    case available
    case selected
    case booked
}

enum BerthType: String, Codable, CaseIterable {
    case lower = "LB"
    case middle = "MB"
    case upper = "UB"
    case sideLower = "SL"
    case sideUpper = "SU"
    case noPreference = "NP"
    
    var displayName: String {
        switch self {
        case .lower: return "Lower"
        case .middle: return "Middle"
        case .upper: return "Upper"
        case .sideLower: return "Side Lower"
        case .sideUpper: return "Side Upper"
        case .noPreference: return "No Preference"
        }
    }
}

enum StationDirectory {
    static let stations: [Station] = [
        Station(id: "", code: "NDLS", name: "New Delhi", city: "New Delhi"),
        Station(id: "", code: "BCT",  name: "Mumbai Central", city: "Mumbai Central"),
        Station(id: "", code: "LKO",  name: "Lucknow Junction", city: "Lucknow Junction"),
        Station(id: "", code: "CNB",  name: "Kanpur Central", city: "Kanpur Central")
        // add more as you use them
    ]

    private static let byCode: [String: Station] = {
        Dictionary(uniqueKeysWithValues: stations.map { ($0.code, $0) })
    }()

    static func station(for code: String) -> Station {
        byCode[code] ?? Station(
            id: "\(UUID())",
            code: code,
            name: code,
            city: code
        )  // fallback
    }
}
