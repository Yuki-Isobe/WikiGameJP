import Foundation
@testable import WikiGameJP

class WikipediaTitleResponseFactory {
    static func create(
        query: WikipediaTitleQuery = WikipediaTitleQueryFactory.create()
    ) -> WikipediaTitleResponse {
        WikipediaTitleResponse(
            query: query
        )
    }
}


class WikipediaTitleQueryFactory {
    static func create(
        random: [WikipediaTitle] = []
    ) -> WikipediaTitleQuery {
        WikipediaTitleQuery(
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
