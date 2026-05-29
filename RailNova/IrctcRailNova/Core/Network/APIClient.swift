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
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 429:
            throw NetworkError.rateLimited
        default:
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
    
    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token if available
        if let token = KeychainManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        if let params = endpoint.queryParams {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components.url
        }
        
        return request
    }
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case rateLimited
    case serverError(Int)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid server response"
        case .unauthorized: return "Session expired. Please login again."
        case .notFound: return "Resource not found"
        case .rateLimited: return "Too many requests. Please try again."
        case .serverError(let code): return "Server error: \(code)"
        case .decodingFailed(let error): return "Data parsing failed: \(error.localizedDescription)"
        }
    }
}
