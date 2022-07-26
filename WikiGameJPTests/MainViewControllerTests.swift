import XCTest
import Nimble
import BrightFutures
import Mockingbird
@testable import WikiGameJP

class MainViewControllerTests: XCTestCase {
    var subject: MainViewController!
    var mockWikipediaRepository: WikipediaRepositoryMock!
    
    override func setUp() {
        super.setUp()
        mockWikipediaRepository = mock(WikipediaRepository.self)
        
        given(mockWikipediaRepository.getTitles()).willReturn(
            Future(value: WikipediaTitleResponseFactory.create())
        )

        subject = MainViewController(
            wikipediaRepository: mockWikipediaRepository
        )
    }
    
    func test_viewDidLoad_getWikipediaTitles() {
        let response = WikipediaTitleResponseFactory.create(
            query: WikipediaQueryFactory.create(
                random: [
                    WikipediaTitleFactory.create(
                        title: "fake-title-1"
                    ),
                    WikipediaTitleFactory.create(
                        title: "fake-title-2"
                    )
                ]
            )
        )
        
        given(mockWikipediaRepository.getTitles()).willReturn(
            Future(value: response)
        )
        
        _ = subject.view
        verify(mockWikipediaRepository.getTitles()).wasCalled()
        subject.view.layoutIfNeeded()
        
        let startLabel = subject.view.findLabel(withId: R.id.MainView_startTitle.rawValue)
        let goalLabel = subject.view.findLabel(withId: R.id.MainView_goalTitle.rawValue)
        expect(startLabel?.text).toEventually(equal("fake-title-1"))
        expect(goalLabel?.text).toEventually(equal("fake-title-2"))
    }
}
