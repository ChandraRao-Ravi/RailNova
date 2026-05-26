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

struct Train: Identifiable, Codable {
    let id: String
    let number: String     // e.g. "12951"
    let name: String       // e.g. "Mumbai Rajdhani"
    let fromStation: Station
    let toStation: Station
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let runsOn: [Bool]     // M T W T F S S
    let classes: [TrainClass]
}

struct TrainClass: Identifiable, Codable {
    let id: String
    let type: TravelClass
    let availability: AvailabilityStatus
    let fare: Double
    let cnfProbability: Int? // 0–100
}

struct CoachLayout: Identifiable, Codable {
    let id: String
    let coachNumber: String  // e.g. "B2"
    let coachType: TravelClass
    let seats: [Seat]
}

struct Seat: Identifiable, Codable, Hashable {
    let id: String
    let number: Int
    let berthType: BerthType
    var status: SeatStatus
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
    
    var displayText: String {
        switch self {
        case .available(let count): return "AVL \(count)"
        case .waitlist(let num): return "WL \(num)"
        case .rac(let num): return "RAC \(num)"
        case .notAvailable: return "N/A"
        }
    }
    
    var isBookable: Bool {
        switch self {
        case .available, .waitlist, .rac: return true
        case .notAvailable: return false
        }
    }
}

enum SeatStatus: String, Codable {
    case available
    case selected
    case booked
}

enum BerthType: String, Codable {
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
