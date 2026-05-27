import Foundation

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - Endpoint Protocol

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParams: [String: String]? { get }
    var body: [String: Any]? { get }
}

// MARK: - Train Endpoints

enum TrainEndpoint: Endpoint {
    case searchTrains(from: String, to: String, date: String, travelClass: String, quota: String)
    case trainDetails(trainNumber: String)
    // others can stay for future

    var path: String {
        switch self {
        case .searchTrains:
            // Backend route: GET /api/search-trains
            return "/search-trains"
        case .trainDetails(let number):
            // Backend route: GET /api/trains/:number
            return "/trains/\(number)"
        default:
            return "/unused" // or fatalError for now
        }
    }

    var method: HTTPMethod { .get }

    var queryParams: [String: String]? {
        switch self {
        case .searchTrains(let from, let to, let date, let travelClass, let quota):
            // Backend expects classCode, not class
            return [
                "from": from,
                "to": to,
                "date": date,
                "classCode": travelClass,
                "quota": quota
            ]
        default:
            return nil
        }
    }

    var body: [String: Any]? { nil }
}

// MARK: - Booking Endpoints

enum BookingEndpoint: Endpoint {
    case createBooking
    case getBookings
    case getBookingDetail(id: String)
    case cancelBooking(id: String)
    case pnrStatus(pnr: String)
    case fileTDR(bookingId: String)
    
    var path: String {
        switch self {
        case .createBooking: return "/bookings"
        case .getBookings: return "/bookings"
        case .getBookingDetail(let id): return "/bookings/\(id)"
        case .cancelBooking(let id): return "/bookings/\(id)/cancel"
        case .pnrStatus(let pnr): return "/pnr/\(pnr)"
        case .fileTDR(let id): return "/bookings/\(id)/tdr"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createBooking: return .post
        case .cancelBooking, .fileTDR: return .patch
        default: return .get
        }
    }
    
    var queryParams: [String: String]? { nil }
    var body: [String: Any]? { nil }
}
