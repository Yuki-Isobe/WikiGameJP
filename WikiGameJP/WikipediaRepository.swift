import BrightFutures
import Foundation

protocol WikipediaRepository {
    func getTitles() -> Future<WikipediaTitleResponse, AppError>
    func getPageInfo(title: String) -> Future<WikipediaPageInfoResponse, AppError>
    func getTitleInfo(startTitle: String, goalTitle: String) -> Future<WikipediaPageInfoResponse, AppError>
}

class WikipediaRepositoryImpl: WikipediaRepository {
    private let http: Http
    private let urlGenerator: WikipediaUrlGenerator
    
    init(
        http: Http = DefaultHttp(),
        urlGenerator: WikipediaUrlGenerator = WikipediaUrlGeneratorImpl()
    ) {
        self.http = http
        self.urlGenerator = urlGenerator
    }
    
    func getTitles() -> Future<WikipediaTitleResponse, AppError> {
        let result = http.get(path: urlGenerator.generateGetTitleUrl()).flatMap { response in
            self.parse(data: response, WikipediaTitleResponse.self)
        }
        
        return result
    }
    
    func getPageInfo(title: String) -> Future<WikipediaPageInfoResponse, AppError> {
        let url = urlGenerator.generateGetPageInfoUrl(title: title)
        let result = http.get(path: url).flatMap { response in
            self.parse(data: response, WikipediaPageInfoResponse.self)
        }
        
        return result
    }
    
    func getTitleInfo(startTitle: String, goalTitle: String) -> Future<WikipediaPageInfoResponse, AppError> {
        let url = urlGenerator.generateGetTitleInfoUrl(startTitle: startTitle, goalTitle: goalTitle)
        let result = http.get(path: url).flatMap { response in
            self.parse(data: response, WikipediaPageInfoResponse.self)
        }
        
        return result
    }
    
    private func parse<T: Decodable>(data: Any, _ type: T.Type) -> Result<T, AppError> {
        guard let validData = data as? Data else {
            return Result.failure(.ParseFailed)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(T.self, from: validData)
            return .success(response)
        } catch let exception {
            print("ERROR: \(exception.localizedDescription)")
            return .failure(.ParseFailed)
        }
        return Result.failure(.ParseFailed)
    }
}
