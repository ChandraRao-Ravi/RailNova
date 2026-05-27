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

//enum MockData {
//    static let ndls = Station(id: "NDLS", code: "NDLS", name: "New Delhi", city: "Delhi")
//    static let bct  = Station(id: "BCT",  code: "BCT",  name: "Mumbai Central", city: "Mumbai")
//    static let csmt = Station(id: "CSMT", code: "CSMT", name: "Mumbai CSMT", city: "Mumbai")
//    static let lko  = Station(id: "LKO",  code: "LKO",  name: "Lucknow Junction", city: "Lucknow")
//    static let cnb  = Station(id: "CNB",  code: "CNB",  name: "Kanpur Central", city: "Kanpur")
//
//    static let ndlsToMumbaiTrains: [Train] = [
//        Train(
//            id: "12951",
//            number: "12951",
//            name: "Mumbai Rajdhani",
//            fromStation: ndls,
//            toStation: bct,
//            departureTime: "16:55",
//            arrivalTime: "09:30",
//            duration: "15h 35m",
//            runsOn: [true, true, true, true, true, true, true],
//            classes: [
//                TrainClass(
//                    id: "12951-1A",
//                    type: .firstAC,
//                    availability: .available(8),
//                    fare: 3155,
//                    cnfProbability: 95
//                ),
//                TrainClass(
//                    id: "12951-2A",
//                    type: .secondAC,
//                    availability: .available(12),
//                    fare: 1765,
//                    cnfProbability: 92
//                ),
//                TrainClass(
//                    id: "12951-3A",
//                    type: .thirdAC,
//                    availability: .available(24),
//                    fare: 1235,
//                    cnfProbability: 90
//                )
//            ]
//        ),
//        Train(
//            id: "12002",
//            number: "12002",
//            name: "Shatabdi Express",
//            fromStation: ndls,
//            toStation: csmt,
//            departureTime: "06:00",
//            arrivalTime: "18:20",
//            duration: "12h 20m",
//            runsOn: [true, true, true, true, true, true, true],
//            classes: [
//                TrainClass(
//                    id: "12002-CC",
//                    type: .chairCar,
//                    availability: .available(3),
//                    fare: 2805,
//                    cnfProbability: 88
//                ),
//                TrainClass(
//                    id: "12002-EC",
//                    type: .executiveChair,
//                    availability: .available(15),
//                    fare: 1680,
//                    cnfProbability: 90
//                )
//            ]
//        ),
//        Train(
//            id: "12416",
//            number: "12416",
//            name: "Garib Rath Express",
//            fromStation: ndls,
//            toStation: bct,
//            departureTime: "14:20",
//            arrivalTime: "07:30",
//            duration: "17h 10m",
//            runsOn: [true, true, true, true, true, true, true],
//            classes: [
//                TrainClass(
//                    id: "12416-3A",
//                    type: .thirdAC,
//                    availability: .available(30),
//                    fare: 1200,
//                    cnfProbability: 85
//                ),
//                TrainClass(
//                    id: "12416-SL",
//                    type: .sleeperClass,
//                    availability: .available(42),
//                    fare: 700,
//                    cnfProbability: 80
//                )
//            ]
//        )
//    ]
//
//    static let lkoToCnbTrains: [Train] = [
//        Train(
//            id: "12004",
//            number: "12004",
//            name: "Lucknow Express",
//            fromStation: lko,
//            toStation: cnb,
//            departureTime: "10:30",
//            arrivalTime: "14:45",
//            duration: "4h 15m",
//            runsOn: [true, true, true, true, true, true, true],
//            classes: [
//                TrainClass(
//                    id: "12004-SL",
//                    type: .sleeperClass,
//                    availability: .available(20),
//                    fare: 320,
//                    cnfProbability: 93
//                )
//            ]
//        )
//    ]
//}
