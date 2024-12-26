import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class SwiftRestClient {
    private enum HTTPMethod: String {
        case GET
        case POST
        case PUT
    }
    
    private enum ResponseError: Error {
        case NoData
        case NoResponse
    }

    public static let shared = SwiftRestClient()
    public typealias RequestCompletion = (Data?, URLResponse?, Error?) -> Void
    public typealias Headers = [String: String]

    private init() {}

    private func call(
        _ url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        headers: Headers? = nil,
        onCompletion: @escaping RequestCompletion
    ) -> Void {
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        request.httpBody = body

        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: onCompletion)

        dataTask.resume()
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private func fallbackCall(
        url: URL,
       method: HTTPMethod,
       body: Data? = nil,
       headers: Headers? = nil
    ) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            self.call(url, method: method, body: body, headers: headers) { data, response, error in
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
        }
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private func call(
        _ url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        headers: Headers? = nil
    ) async throws -> (Data, URLResponse) {
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || (os(Linux) && compiler(>=6.0))
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        request.httpBody = body
        
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *){
            return try await URLSession.shared.data(for: request)
        } else {
            return try await fallbackCall(url: url, method: method, body: body, headers: headers)
        }
        #else
        return try await fallbackCall(url: url, method: method, body: body, headers: headers)
        #endif
    }

    public func get(_ url: URL, headers: Headers? = nil, onCompletion: @escaping RequestCompletion) -> Void {
        call(url, method: .GET, body: nil, headers: headers, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func get(_ url: URL, headers: Headers? = nil) async throws -> (Data, URLResponse) {
        return try await call(url, method: .GET, body: nil, headers: headers)
    }

    public func post(_ url: URL, body: Data? = nil, headers: Headers? = nil, onCompletion: @escaping RequestCompletion) -> Void {
        call(url, method: .POST, body: body, headers: headers, onCompletion: onCompletion)
    }

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func post(_ url: URL, body: Data? = nil, headers: Headers? = nil) async throws -> (Data, URLResponse) {
        return try await call(url, method: .POST, body: body, headers: headers)
    }
    
    public func put(_ url: URL, body: Data? = nil, headers: Headers? = nil, onCompletion: @escaping RequestCompletion) -> Void {
        call(url, method: .PUT, body: body, headers: headers, onCompletion: onCompletion)
    }

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func put(_ url: URL, body: Data? = nil, headers: Headers? = nil) async throws -> (Data, URLResponse) {
        return try await call(url, method: .PUT, body: body, headers: headers)
    }
}
