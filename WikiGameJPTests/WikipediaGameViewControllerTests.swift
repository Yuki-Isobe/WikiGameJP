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
        
        given(mockWikipediaRepository.getPageInfo(title: any())).willReturn(
            Future(value: WikipediaPageInfoResponseFactory.create())
        )
    }
    
    func test_viewDidLoad_getWikipediaInfo_and_display_labels() {
        let titleStart = "fake-title-start"
        let titleGoal = "fake-title-goal"
        
        initSubject(titleStart: titleStart, titleGoal: titleGoal)
        _ = subject.view
        
        let startLabel = subject.view.findLabel(withId: R.id.GameView_startTitle.rawValue)
        let goalLabel = subject.view.findLabel(withId: R.id.GameView_goalTitle.rawValue)
        
        verify(mockWikipediaRepository.getPageInfo(title: titleStart)).wasCalled()
        expect(startLabel?.text).toEventually(equal(titleStart))
        expect(goalLabel?.text).toEventually(equal(titleGoal))
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
