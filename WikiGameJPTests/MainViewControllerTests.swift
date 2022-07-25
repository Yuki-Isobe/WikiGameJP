import XCTest
import Nimble
import Mockingbird
@testable import WikiGameJP

class MainViewControllerTests: XCTestCase {
    var subject: MainViewController!
    var mockWikipediaRepository: WikipediaRepositoryMock!
    
    override func setUp() {
        super.setUp()
        mockWikipediaRepository = mock(WikipediaRepository.self)
//        given(mockWikipediaRepository.getTitles()).willReturn(["", ""])

        subject = MainViewController(
            wikipediaRepository: mockWikipediaRepository
        )
    }
    
    func test_viewDidLoad_getWikipediaTitles() {
        let title = [
            "fake-title-1",
            "fake-title-2"
        ]
        
//        given(mockWikipediaRepository.getTitles()).willReturn(title)
        
        _ = subject.view
        
        verify(mockWikipediaRepository.getTitles()).wasCalled()
        
        let startLabel = subject.view.findLabel(withId: R.id.MainView_startTitle.rawValue)
        let goalLabel = subject.view.findLabel(withId: R.id.MainView_goalTitle.rawValue)
        expect(startLabel?.text).to(equal("fake-title-1"))
        expect(goalLabel?.text).to(equal("fake-title-2"))
    }
}
