import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@available(iOS 13.0, *)
public class AsyncRestClient {
    private enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private enum ResponseError: Error {
        case NoData
        case NoResponse
    }

    public static let shared = AsyncRestClient()
    public typealias RequestCompletion = (Data?, URLResponse?, Error?) -> Void
    public typealias Headers = [String: String]

    private init() {}

    private func call(
        _ url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        headers: Headers? = nil
    ) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        request.httpBody = body
        
        if #available(macOS 12.0, iOS 15.0, *) {
            return try await URLSession.shared.data(for: request)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let data = data else {
                        continuation.resume(throwing: ResponseError.NoData)
                        return
                    }
                    
                    guard let response = response else {
                        continuation.resume(throwing: ResponseError.NoResponse)
                        return
                    }
                    
                    continuation.resume(returning: (data, response))
                }

                dataTask.resume()
            }
        }
    }

    public func get(_ url: URL, headers: Headers? = nil) async throws -> (Data, URLResponse) {
        return try await call(url, method: .GET, body: nil, headers: headers)
    }

    public func post(_ url: URL, body: Data? = nil, headers: Headers? = nil) async throws -> (Data, URLResponse) {
        return try await call(url, method: .POST, body: body, headers: headers)
    }
}
