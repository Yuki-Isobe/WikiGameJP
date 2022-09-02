import Foundation

struct WikipediaPageInfoResponse: Decodable, Equatable {
    var query: WikipediaPageInfoQuery
}

struct WikipediaPageInfoQuery: Decodable, Equatable {
    var pages: [String: WikipediaPageInfo]
}

struct WikipediaPageInfo: Decodable, Equatable {
    var pageid: Int
    var title: String
    var revisions: [WikipediaPageInfoRevision]
}

struct WikipediaPageInfoRevision: Decodable, Equatable {
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "*"
    }
}
