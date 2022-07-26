import Foundation

protocol WikipediaUrlGenerator {
    func generateGetTitleUrl() -> String
}

class WikipediaUrlGeneratorImpl: WikipediaUrlGenerator {
    private let basePath = "https://ja.wikipedia.org/w/api.php"

    func generateGetTitleUrl() -> String {
        let query = "?action=query&format=json&list=random&rnnamespace=0&rnlimit=2"
        
        return basePath + query
    }
}
