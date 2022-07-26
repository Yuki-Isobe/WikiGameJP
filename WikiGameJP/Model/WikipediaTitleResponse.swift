import Foundation

struct WikipediaTitleResponse: Decodable, Equatable {
    var query: WikipediaQuery
}

struct WikipediaQuery: Decodable, Equatable {
    var random: [WikipediaTitle]
}

struct WikipediaTitle: Decodable, Equatable {
    var id: Int
    var title: String
}
