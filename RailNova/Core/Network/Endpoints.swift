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
    case coachLayout(trainNumber: String, coachType: String, date: String)
    case liveStatus(trainNumber: String)
    case fareCalendar(trainNumber: String, from: String, to: String)
    case stationSearch(query: String)
    
    var path: String {
        switch self {
        case .searchTrains: return "/trains/search"
        case .trainDetails(let number): return "/trains/\(number)"
        case .coachLayout(let number, _, _): return "/trains/\(number)/layout"
        case .liveStatus(let number): return "/trains/\(number)/live"
        case .fareCalendar(let number, _, _): return "/trains/\(number)/fare-calendar"
        case .stationSearch: return "/stations/search"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var queryParams: [String: String]? {
        switch self {
        case .searchTrains(let from, let to, let date, let travelClass, let quota):
            return ["from": from, "to": to, "date": date, "class": travelClass, "quota": quota]
        case .coachLayout(_, let coachType, let date):
            return ["coachType": coachType, "date": date]
        case .fareCalendar(_, let from, let to):
            return ["from": from, "to": to]
        case .stationSearch(let query):
            return ["q": query]
        default: return nil
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
