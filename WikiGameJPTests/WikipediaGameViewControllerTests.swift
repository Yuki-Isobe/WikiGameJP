import XCTest
import Nimble
import BrightFutures
import Mockingbird
@testable import WikiGameJP

class WikipediaGameViewControllerTests: XCTestCase {
    var subject: WikipediaGameViewController!
    
    private var routerSpy: NavigationRouterSpy!
    private var mockWikipediaRepository: WikipediaRepositoryMock!

    override func setUp() {
        super.setUp()
        
        routerSpy = NavigationRouterSpy()
        mockWikipediaRepository = mock(WikipediaRepository.self)
    }
    
    func test_viewDidLoad_getWikipediaInfo() {
        let titleStart = "fake-title-start"
        let titleGoal = "fake-title-goal"
        
        initSubject(titleStart: titleStart, titleGoal: titleGoal)
        _ = subject.view
        
        verify(mockWikipediaRepository.getPageInfo(title: titleStart)).wasCalled()
    }
    
    private func initSubject(titleStart: String = "", titleGoal: String = "") {
        subject = WikipediaGameViewController(
            router: routerSpy,
            wikipediaRepository: mockWikipediaRepository,
            titleStart: titleStart,
            titleGoal: titleGoal
        )
    }
}
