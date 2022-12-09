import Foundation
@testable import WikiGameJP

class WikipediaPageInfoResponseFactory {
    static func create(
        query: WikipediaPageInfoQuery = WikipediaPageInfoQueryFactory.create()
    ) -> WikipediaPageInfoResponse {
        WikipediaPageInfoResponse(
            query: query
        )
    }
}

class WikipediaPageInfoQueryFactory {
    static func create(
        pages: [String: WikipediaPageInfo] = [:]
    ) -> WikipediaPageInfoQuery {
        WikipediaPageInfoQuery(
            pages: pages
        )
    }
}

class WikipediaPageInfoFactory {
    static func create(
        pageid: Int? = -1,
        title: String = "",
        missing: String? = nil,
        revisions: [WikipediaPageInfoRevision]? = nil
    ) -> WikipediaPageInfo {
        WikipediaPageInfo(
            pageid: pageid,
            title: title,
            missing: missing,
            revisions: revisions
        )
    }
}

class WikipediaPageInfoRevisionFactory {
    static func create(
        content: String = ""
    ) -> WikipediaPageInfoRevision {
        WikipediaPageInfoRevision(
            content: content
        )
    }
}
