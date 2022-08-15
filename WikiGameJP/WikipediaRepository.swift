import BrightFutures
import Foundation

protocol WikipediaRepository {
    func getTitles() -> Future<WikipediaTitleResponse, AppError>
    func getInfo(title: String)
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
    
    func getInfo(title: String) {
        print("not yet")
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
        } catch _ {
            return .failure(.ParseFailed)
        }
        return Result.failure(.ParseFailed)
    }
}
