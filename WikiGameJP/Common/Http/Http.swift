import Foundation
import BrightFutures

extension TimeInterval {
    // https://developer.apple.com/documentation/foundation/urlrequest/2011457-init
    static let defaultURLRequestTimeout: TimeInterval = 60.0
}

protocol Http {
    func get(path: String, basePath: String?, headers: [String: String]?, timeoutInterval: TimeInterval) -> Future<Any, AppError>
    func post(request: URLRequest) -> Future<Any, AppError>
    func put(request: URLRequest) -> Future<Any, AppError>
}

extension Http {
    func get(path: String) -> Future<Any, AppError> {
        get(path: path, basePath: nil, headers: nil, timeoutInterval: .defaultURLRequestTimeout)
    }

    func get(path: String, headers: [String: String]) -> Future<Any, AppError> {
        get(path: path, basePath: nil, headers: headers, timeoutInterval: .defaultURLRequestTimeout)
    }

    func get(path: String, basePath: String) -> Future<Any, AppError> {
        get(path: path, basePath: basePath, headers: nil, timeoutInterval: .defaultURLRequestTimeout)
    }

    func get(path: String, timeoutInterval: TimeInterval) -> Future<Any, AppError> {
        get(path: path, basePath: nil, headers: nil, timeoutInterval: timeoutInterval)
    }
}

protocol CancelableHttpProtocol: Http {
    func get_cancelable(path: String, basePath: String, headers: [String: String], timeoutInterval: TimeInterval)
        -> (promise: Future<Any, AppError>, task: URLSessionDataTaskProtocol?)
}

extension CancelableHttpProtocol {
    func get_cancelable(path: String, basePath: String)
        -> (promise: Future<Any, AppError>, task: URLSessionDataTaskProtocol?) {
        get_cancelable(path: path, basePath: basePath, headers: [:], timeoutInterval: .defaultURLRequestTimeout)
    }
}
