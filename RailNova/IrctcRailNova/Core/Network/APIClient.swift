//
//  APIClient.swift
//  IrctcRailNova
//

import Foundation

// MARK: - API Client

final class APIClient {

    static let shared = APIClient()

    private let session: URLSession
    private let baseURL = "https://rail-nova-backend-production.up.railway.app/api"

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    func request<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        let urlRequest = try buildRequest(for: endpoint)
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }

        case 400:
            let message = extractServerMessage(from: data) ?? "Bad request"
            throw NetworkError.badRequest(message)

        case 401:
            throw NetworkError.unauthorized

        case 404:
            throw NetworkError.notFound

        case 409:
            let message = extractServerMessage(from: data) ?? "Conflict"
            throw NetworkError.conflict(message)

        case 429:
            throw NetworkError.rateLimited

        default:
            let message = extractServerMessage(from: data)
            throw NetworkError.serverError(httpResponse.statusCode, message)
        }
    }

    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let base = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var finalURL = base

        if let params = endpoint.queryParams, !params.isEmpty {
            var components = URLComponents(url: base, resolvingAgainstBaseURL: false)

            components?.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }

            guard let urlWithParams = components?.url else {
                throw NetworkError.invalidURL
            }

            finalURL = urlWithParams
        }

        print("request url: \(finalURL.absoluteString)")

        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = KeychainService.shared.getToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = endpoint.body, !body.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        return request
    }

    private func extractServerMessage(from data: Data) -> String? {
        if let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let error = object["error"] as? String, !error.isEmpty {
                return error
            }

            if let message = object["message"] as? String, !message.isEmpty {
                return message
            }
        }

        if let text = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !text.isEmpty {
            return text
        }

        return nil
    }
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badRequest(String)
    case unauthorized
    case notFound
    case conflict(String)
    case rateLimited
    case serverError(Int, String?)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"

        case .invalidResponse:
            return "Invalid server response"

        case .badRequest(let message):
            return message

        case .unauthorized:
            return "Session expired. Please login again."

        case .notFound:
            return "Resource not found"

        case .conflict(let message):
            return message

        case .rateLimited:
            return "Too many requests. Please try again."

        case .serverError(let code, let message):
            if let message, !message.isEmpty {
                return message
            }
            return "Server error: \(code)"

        case .decodingFailed(let error):
            return "Data parsing failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - Auth Convenience Methods

extension APIClient {
    func signup(fullName: String, email: String, password: String) async throws -> AuthResponse {
        try await request(
            endpoint: AuthEndpoint.signup(fullName: fullName, email: email, password: password),
            responseType: AuthResponse.self
        )
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        try await request(
            endpoint: AuthEndpoint.login(email: email, password: password),
            responseType: AuthResponse.self
        )
    }

    func loginWithSocial(provider: String, firebaseIdToken: String) async throws -> AuthResponse {
        try await request(
            endpoint: AuthEndpoint.socialLogin(provider: provider, firebaseIdToken: firebaseIdToken),
            responseType: AuthResponse.self
        )
    }

    func getMe() async throws -> MeResponse {
        try await request(
            endpoint: AuthEndpoint.me,
            responseType: MeResponse.self
        )
    }

    func updateProfile(
        profile: UpdateProfileRequest
    ) async throws -> MeResponse {
        try await request(
            endpoint: AuthEndpoint.updateProfile(
                fullName: profile.fullName,
                phone: profile.phone,
                dob: profile.dob,
                gender: profile.gender,
                nationality: profile.nationality,
                city: profile.city,
                state: profile.state
            ),
            responseType: MeResponse.self
        )
    }
}
