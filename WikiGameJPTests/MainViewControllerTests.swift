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
            Future(value: WikipediaTitleResponseFactory.create(
                query: WikipediaQueryFactory.create(
                    random: [
                        WikipediaTitleFactory.create(),
                        WikipediaTitleFactory.create()
                    ]
                )
            )
            )
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
    
    func test_tapTitleSwapButton() {
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
        subject.view.layoutIfNeeded()
        
        let startLabel = subject.view.findLabel(withId: R.id.MainView_startTitle.rawValue)
        let goalLabel = subject.view.findLabel(withId: R.id.MainView_goalTitle.rawValue)
        expect(startLabel?.text).toEventually(equal("fake-title-1"))
        expect(goalLabel?.text).toEventually(equal("fake-title-2"))
        
        let titleSwapButton = subject.view.findButton(withId: R.id.MainView_titleSwapButton.rawValue)
        
        titleSwapButton?.tap()
        
        let newStartLabel = subject.view.findLabel(withId: R.id.MainView_startTitle.rawValue)
        let newGoalLabel = subject.view.findLabel(withId: R.id.MainView_goalTitle.rawValue)
        expect(newStartLabel?.text).toEventually(equal("fake-title-2"))
        expect(newGoalLabel?.text).toEventually(equal("fake-title-1"))
    }
}
