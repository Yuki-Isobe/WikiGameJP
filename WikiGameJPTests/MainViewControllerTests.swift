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
        given(mockWikipediaRepository.getTitles()).willReturn([])

        subject = MainViewController(
            wikipediaRepository: mockWikipediaRepository
        )
    }
    
    func test_viewDidLoad_getWikipediaTitles() {

        _ = subject.view
        
        verify(mockWikipediaRepository.getTitles()).wasCalled()
    }
}
