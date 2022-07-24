import Foundation

protocol WikipediaRepository {
    func getTitles() -> [String]
}

class WikipediaRepositoryImpl: WikipediaRepository {
    func getTitles() -> [String] {
        [""]
    }
}
