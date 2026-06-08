//
//  Endpoints.swift
//  IrctcRailNova
//

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

    var path: String {
        switch self {
        case .searchTrains:
            return "/search-trains"
        case .trainDetails(let number):
            return "/trains/\(number)"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryParams: [String: String]? {
        switch self {
        case .searchTrains(let from, let to, let date, let travelClass, let quota):
            return [
                "from": from,
                "to": to,
                "date": date,
                "classCode": travelClass,
                "quota": quota
            ]
        case .trainDetails:
            return nil
        }
    }

    var body: [String: Any]? {
        nil
    }
}

// MARK: - Booking Endpoints

enum BookingEndpoint: Endpoint {
    case createBooking(BookingCreateRequest)
    case getBookingsForUser(userId: String)
    case getBookingDetail(id: String)
    case cancelBooking(id: String)
    case pnrStatus(pnr: String)
    case fileTDR(bookingId: String)

    var path: String {
        switch self {
        case .createBooking(let req):
            return "/users/\(req.userId)/bookings"
        case .getBookingsForUser(let userId):
            return "/users/\(userId)/bookings"
        case .getBookingDetail(let id):
            return "/bookings/\(id)"
        case .cancelBooking(let id):
            return "/bookings/\(id)/cancel"
        case .pnrStatus(let pnr):
            return "/pnr/\(pnr)"
        case .fileTDR(let bookingId):
            return "/bookings/\(bookingId)/tdr"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createBooking:
            return .post
        case .cancelBooking, .fileTDR:
            return .patch
        case .getBookingsForUser, .getBookingDetail, .pnrStatus:
            return .get
        }
    }

    var queryParams: [String: String]? {
        nil
    }

    var body: [String: Any]? {
        switch self {
        case .createBooking(let req):
            return [
                "trainNumber": req.trainNumber,
                "journeyDate": req.journeyDate,
                "fromStation": req.from,
                "toStation": req.to,
                "totalFare": req.totalFare
            ]
        case .getBookingsForUser,
             .getBookingDetail,
             .cancelBooking,
             .pnrStatus,
             .fileTDR:
            return nil
        }
    }
}

// MARK: - Auth Endpoints

enum AuthEndpoint: Endpoint {
    case signup(fullName: String, email: String, password: String)
    case login(email: String, password: String)
    case socialLogin(provider: String, firebaseIdToken: String)
    case me
    case updateProfile(
        fullName: String?,
        phone: String?,
        dob: String?,
        gender: String?,
        nationality: String?,
        city: String?,
        state: String?
    )

    var path: String {
        switch self {
        case .signup:
            return "/auth/signup"
        case .login:
            return "/auth/login"
        case .socialLogin:
            return "/auth/social-login"
        case .me:
            return "/me"
        case .updateProfile:
            return "/me/profile"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .signup, .login, .socialLogin:
            return .post
        case .me:
            return .get
        case .updateProfile:
            return .patch
        }
    }

    var queryParams: [String: String]? {
        nil
    }

    var body: [String: Any]? {
        switch self {
        case let .signup(fullName, email, password):
            return [
                "fullName": fullName,
                "email": email,
                "password": password
            ]

        case let .login(email, password):
            return [
                "email": email,
                "password": password
            ]

        case let .socialLogin(provider, firebaseIdToken):
            return [
                "provider": provider,
                "firebaseIdToken": firebaseIdToken
            ]

        case let .updateProfile(fullName, phone, dob, gender, nationality, city, state):
            var payload: [String: Any] = [:]

            if let fullName { payload["fullName"] = fullName }
            if let phone { payload["phone"] = phone }
            if let dob { payload["dob"] = dob }
            if let gender { payload["gender"] = gender }
            if let nationality { payload["nationality"] = nationality }
            if let city { payload["city"] = city }
            if let state { payload["state"] = state }

            return payload

        case .me:
            return nil
        }
    }
}
