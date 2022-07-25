import Foundation
import BrightFutures

struct DefaultHttp: CancelableHttpProtocol {
    let urlSession: URLSessionProtocol

    init(
        urlSession: URLSessionProtocol = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: nil
        )
    ) {
        self.urlSession = urlSession
    }

    func get_cancelable(path: String, basePath: String, headers: [String: String], timeoutInterval: TimeInterval)
        -> (promise: Future<Any, AppError>, task: URLSessionDataTaskProtocol?) {
        return (promise: Future(), task: nil)
    }


    func get(path: String, basePath: String?, headers: [String: String]?, timeoutInterval: TimeInterval) -> Future<Any, AppError> {
        let responsePromise = Promise<Any, AppError>()
        var task: URLSessionDataTaskProtocol? = nil

        guard let url = URL(string: path) else {
            return Future()
        }
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.allHTTPHeaderFields = headers
        task = urlSession.dataTask(with: request, completionHandler: {
            (data, urlResponse, error) in

            guard error == nil else {
                if let error = error as NSError?, error.code == NSURLErrorCancelled {
                    responsePromise.failure(.Cancelled)
                } else {
                    responsePromise.failure(.GetFailed)
                }
                return
            }

            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                responsePromise.failure(AppError.GetFailed)
                return
            }

            if httpUrlResponse.statusCode != 200 {
                responsePromise.failure(AppError.GetFailed)
                return
            }

            guard let data = data else {
                responsePromise.failure(AppError.GetFailed)
                return
            }

            responsePromise.success(data)
        })
        task?.resume()
        return responsePromise.future
    }

    func post(request: URLRequest) -> Future<Any, AppError> {
        Future()
    }

    func put(request: URLRequest) -> Future<Any, AppError> {
        Future()
    }

    private func getBasePath() -> String {
        return ""
    }
}
