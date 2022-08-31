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
    
    override func setUp() {
        super.setUp()
        
        mockHttp = mock(Http.self)
        mockWikipediaUrlGenerator = mock(WikipediaUrlGenerator.self)
        
        given(mockWikipediaUrlGenerator.generateGetTitleUrl()).willReturn(fakeGetTitleUrl)
        given(mockWikipediaUrlGenerator.generateGetPageInfoUrl()).willReturn(fakeGetPageInfoUrl)

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
        
        given(mockHttp.get(path: url, basePath: any(), headers: any(), timeoutInterval: any())).willReturn(
            Future(value: jsonData!)
        )
        
        let future = subject.getPageInfo(title: title)
        
        let expectResponse =
        WikipediaPageInfoResponseFactory.create(
            query: WikipediaPageInfoQueryFactory.create(
                pages: [2115905: WikipediaPageInfoFactory.create(
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
}
