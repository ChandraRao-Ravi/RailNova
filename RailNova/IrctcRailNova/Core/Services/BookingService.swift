//
//  BookingService.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

final class BookingService {
    static let shared = BookingService()
    private let apiClient = APIClient.shared

    private init() {}

    func createBooking(request: BookingCreateRequest) async throws -> BookingResponseDTO {
        let endpoint = BookingEndpoint.createBooking(request)
        return try await apiClient.request(endpoint: endpoint, responseType: BookingResponseDTO.self)
    }

    func getBookings(for userId: String) async throws -> [BookingResponseDTO] {
        let endpoint = BookingEndpoint.getBookingsForUser(userId: userId)
        return try await apiClient.request(endpoint: endpoint, responseType: [BookingResponseDTO].self)
    }
}
