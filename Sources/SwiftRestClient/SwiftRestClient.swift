import Foundation

public class SwiftRestCaller {
    private enum HTTPMethod: String {
        case GET
        case POST
    }

    public static let shared = SwiftRestCaller()
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

    public func get(_ url: URL, headers: Headers? = nil, onCompletion: @escaping RequestCompletion) -> Void {
        call(url, method: .GET, body: nil, headers: headers, onCompletion: onCompletion)
    }

    public func post(_ url: URL, body: Data? = nil, headers: Headers? = nil, onCompletion: @escaping RequestCompletion) -> Void {
        call(url, method: .POST, body: body, headers: headers, onCompletion: onCompletion)
    }
}
