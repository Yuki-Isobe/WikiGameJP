import Foundation
@testable import WikiGameJP

class WikipediaTitleResponseFactory {
    static func create(
        query: WikipediaQuery = WikipediaQueryFactory.create()
    ) -> WikipediaTitleResponse {
        WikipediaTitleResponse(
            query: query
        )
    }
}


class WikipediaQueryFactory {
    static func create(
        random: [WikipediaTitle] = []
    ) -> WikipediaQuery {
        WikipediaQuery(
            random: random
        )
    }
}

class WikipediaTitleFactory {
    static func create(
        id: Int = -1,
        title: String = ""
    ) -> WikipediaTitle {
        WikipediaTitle(
            id: id,
            title: title
        )
    }
}
