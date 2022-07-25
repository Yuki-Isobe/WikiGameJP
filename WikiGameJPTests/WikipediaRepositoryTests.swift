import XCTest
import Nimble
import Mockingbird
import BrightFutures
@testable import WikiGameJP

class WikipediaRepositoryTests: XCTestCase {
    var subject: WikipediaRepositoryImpl!
    
    var mockHttp: HttpMock!
    var mockWikipediaUrlGenerator: WikipediaUrlGeneratorMock!
    
    override func setUp() {
        super.setUp()
        
        mockHttp = mock(Http.self)
        mockWikipediaUrlGenerator = mock(WikipediaUrlGenerator.self)
        
        given(mockWikipediaUrlGenerator.generateUrl()).willReturn("http://fake-url/")

        subject = WikipediaRepositoryImpl(
            http: mockHttp,
            urlGenerator: mockWikipediaUrlGenerator
        )
    }
    
    func test_getTitles() {
        let json = "{\"batchcomplete\": \"\",\"continue\": {\"rncontinue\": \"0.690578826146|0.690582364492|4327842|0\",\"continue\": \"-||\"},\"query\": {\"random\": [{\"id\": 1,\"ns\": 0,\"title\": \"test-title-1\"},{\"id\": 2,\"ns\": 0,\"title\": \"test-title-2\"}]}}"
        let jsonData = json.data(using: .utf8)
        
        given(mockHttp.get(path: "http://fake-url/", basePath: any(), headers: any(), timeoutInterval: any())).willReturn(
            Future(value: jsonData!)
        )
        
        let future = subject.getTitles()
        let expectResponse =
        WikipediaTitleResponseFactory.create(
            query: WikipediaQueryFactory.create(
                random: [
                        WikipediaTitleFactory.create(id: 1, title: "test-title-1"),
                        WikipediaTitleFactory.create(id: 2, title: "test-title-2")
                    ]
                )
            )
        
        expect(future.value).toEventually(equal(expectResponse))
    }
}
