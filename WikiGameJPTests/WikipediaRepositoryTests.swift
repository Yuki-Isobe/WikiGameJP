import XCTest
import Nimble
import Mockingbird
import BrightFutures
@testable import WikiGameJP

class WikipediaRepositoryTests: XCTestCase {
    var subject: WikipediaRepositoryImpl!
    
    var mockHttp: HttpMock!
    var mockWikipediaUrlGenerator: WikipediaUrlGeneratorMock!
    
    let fakeGetTitleUrl = "http://fake-url/getTitle/"
    let fakeGetPageInfoUrl = "http://fake-url/getInfo/"
    let fakeGetTitleInfoUrl = "http://fake-url/getTitleInfo/"
    
    override func setUp() {
        super.setUp()
        
        mockHttp = mock(Http.self)
        mockWikipediaUrlGenerator = mock(WikipediaUrlGenerator.self)
        
        given(mockWikipediaUrlGenerator.generateGetTitleUrl()).willReturn(fakeGetTitleUrl)
        given(mockWikipediaUrlGenerator.generateGetPageInfoUrl(title: any())).willReturn(fakeGetPageInfoUrl)

        subject = WikipediaRepositoryImpl(
            http: mockHttp,
            urlGenerator: mockWikipediaUrlGenerator
        )
    }
    
    func test_getTitles() {
        let json = "{\"batchcomplete\": \"\",\"continue\": {\"rncontinue\": \"0.690578826146|0.690582364492|4327842|0\",\"continue\": \"-||\"},\"query\": {\"random\": [{\"id\": 1,\"ns\": 0,\"title\": \"test-title-1\"},{\"id\": 2,\"ns\": 0,\"title\": \"test-title-2\"}]}}"
        let jsonData = json.data(using: .utf8)
        
        given(mockHttp.get(path: fakeGetTitleUrl, basePath: any(), headers: any(), timeoutInterval: any())).willReturn(
            Future(value: jsonData!)
        )
        
        let future = subject.getTitles()
        let expectResponse =
        WikipediaTitleResponseFactory.create(
            query: WikipediaTitleQueryFactory.create(
                random: [
                        WikipediaTitleFactory.create(id: 1, title: "test-title-1"),
                        WikipediaTitleFactory.create(id: 2, title: "test-title-2")
                    ]
                )
            )
        
        expect(future.value).toEventually(equal(expectResponse))
    }
    
    func test_getInfo() {
        let title = "fake-title"
        let url = fakeGetPageInfoUrl + title
        
        let json = "{\"batchcomplete\":\"\",\"warnings\":{\"main\":{\"*\":\"fake-main\"},\"revisions\":{\"*\":\"fake-revisions\"}},\"query\":{\"normalized\":[{\"from\":\"fake-normalized-from\",\"to\":\"fake-normalized-to\"}],\"pages\":{\"2115905\":{\"pageid\":2115905,\"ns\":0,\"title\":\"fake-title\",\"revisions\":[{\"*\":\"fake-text\"}]}}}}"
        let jsonData = json.data(using: .utf8)
        
        given(mockWikipediaUrlGenerator.generateGetPageInfoUrl(title: title)).willReturn(url)
        
        given(mockHttp.get(path: url, basePath: any(), headers: any(), timeoutInterval: any())).willReturn(
            Future(value: jsonData!)
        )
        
        let future = subject.getPageInfo(title: title)
        
        let expectResponse =
        WikipediaPageInfoResponseFactory.create(
            query: WikipediaPageInfoQueryFactory.create(
                pages: ["2115905": WikipediaPageInfoFactory.create(
                    pageid: 2115905,
                    title: "fake-title",
                    revisions: [
                        WikipediaPageInfoRevisionFactory.create(
                            content: "fake-text"
                        )
                    ]
                )
                ]
            )
        )
        
        expect(future.value).toEventually(equal(expectResponse))
    }
    
    func test_getTitleInfo() {
        let startTitle = "fake-start-title"
        let goalTitle = "fake-goal-title"
        let url = fakeGetTitleInfoUrl
        
        let json = "{\"warnings\":{\"main\":{\"*\":\"Unrecognized parameter: rnnamespace.\"}},\"batchcomplete\":\"\",\"query\":{\"normalized\":[{\"from\":\"fake-start-title\",\"to\":\"Fake-start-title\"},{\"from\":\"fake-goal-title\",\"to\":\"Fake-goal-title\"}],\"pages\":{\"1\":{\"pageid\":1,\"ns\":0,\"title\":\"fake-start-title\"},\"2\":{\"pageid\":2,\"ns\":0,\"title\":\"fake-goal-title\"}}}}"
        let jsonData = json.data(using: .utf8)
        
        given(mockWikipediaUrlGenerator.generateGetTitleInfoUrl(startTitle: startTitle, goalTitle: goalTitle)).willReturn(url)
        
        given(mockHttp.get(path: url, basePath: any(), headers: any(), timeoutInterval: any())).willReturn(
            Future(value: jsonData!)
        )
        
        let future = subject.getTitleInfo(startTitle: startTitle, goalTitle: goalTitle)
        
        let expectResponse =
        WikipediaPageInfoResponseFactory.create(
            query: WikipediaPageInfoQueryFactory.create(
                pages: [
                    "1": WikipediaPageInfoFactory.create(
                    pageid: 1,
                    title: "fake-start-title"
                    ),
                    "2": WikipediaPageInfoFactory.create(
                    pageid: 2,
                    title: "fake-goal-title"
                    )
                ]
            )
        )
        
        expect(future.value).toEventually(equal(expectResponse))
    }
    
    
    func test_getTitleInfo_when_title_is_not_exist() {
        let startTitle = "fake-start-title"
        let goalTitle = "fake-goal-title-not-exits"
        let url = fakeGetTitleInfoUrl
        
        let json = "{\"warnings\":{\"main\":{\"*\":\"Unrecognized parameter: rnnamespace.\"}},\"batchcomplete\":\"\",\"query\":{\"normalized\":[{\"from\":\"fake-start-title\",\"to\":\"Fake-start-title\"},{\"from\":\"fake-goal-title\",\"to\":\"Fake-goal-title\"}],\"pages\":{\"1\":{\"pageid\":1,\"ns\":0,\"title\":\"fake-start-title\"},\"-1\":{\"missing\":\"\",\"ns\":0,\"title\":\"fake-goal-title-not-exits\"}}}}"
        let jsonData = json.data(using: .utf8)
        
        given(mockWikipediaUrlGenerator.generateGetTitleInfoUrl(startTitle: startTitle, goalTitle: goalTitle)).willReturn(url)
        
        given(mockHttp.get(path: url, basePath: any(), headers: any(), timeoutInterval: any())).willReturn(
            Future(value: jsonData!)
        )
        
        let future = subject.getTitleInfo(startTitle: startTitle, goalTitle: goalTitle)
        
        let expectResponse =
        WikipediaPageInfoResponseFactory.create(
            query: WikipediaPageInfoQueryFactory.create(
                pages: [
                    "1": WikipediaPageInfoFactory.create(
                    pageid: 1,
                    title: "fake-start-title"
                    ),
                    "-1": WikipediaPageInfoFactory.create(
                    pageid: nil,
                    title: "fake-goal-title-not-exits",
                    missing: ""
                    )
                ]
            )
        )
        
        expect(future.value).toEventually(equal(expectResponse))
    }
}
