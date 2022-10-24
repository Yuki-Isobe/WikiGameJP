import XCTest
import Nimble
import BrightFutures
import Mockingbird
@testable import WikiGameJP

class MainViewControllerTests: XCTestCase {
    var subject: MainViewController!
    
    private var routerSpy: NavigationRouterSpy!
    var mockWikipediaRepository: WikipediaRepositoryMock!
    
    let navigationController = UINavigationController()
    
    override func setUp() {
        super.setUp()
        
        routerSpy = NavigationRouterSpy()
        mockWikipediaRepository = mock(WikipediaRepository.self)
        
        given(mockWikipediaRepository.getTitles()).willReturn(
            Future(value: WikipediaTitleResponseFactory.create(
                query: WikipediaTitleQueryFactory.create(
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
            )
        )

        subject = MainViewController(
            router: routerSpy,
            wikipediaRepository: mockWikipediaRepository
        )
        
        navigationController.viewControllers = [
            subject
        ]
    }
    
    func test_viewDidLoad_getWikipediaTitles() {
        _ = subject.view
        verify(mockWikipediaRepository.getTitles()).wasCalled()
        subject.view.layoutIfNeeded()
        
        let startLabel = subject.view.findLabel(withId: R.id.MainView_startTitle.rawValue)
        let goalLabel = subject.view.findLabel(withId: R.id.MainView_goalTitle.rawValue)
        expect(startLabel?.text).toEventually(equal("fake-title-1"))
        expect(goalLabel?.text).toEventually(equal("fake-title-2"))
    }
    
    func test_tapTitleSwapButton() {
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
    
    func test_tapTitleReloadButton() {
        _ = subject.view
        verify(mockWikipediaRepository.getTitles()).wasCalled(exactly(1))
        
        let titleReloadButton = subject.view.findButton(withId: R.id.MainView_titleReloadButton.rawValue)
        
        titleReloadButton?.tap()
        subject.view.layoutIfNeeded()
        
        verify(mockWikipediaRepository.getTitles()).wasCalled(exactly(2))
    }
    
    func test_tapGameStartButton() {
        let startTitle = "fake-start-title"
        let wikipediaTitleResponce = WikipediaTitleResponseFactory.create(
            query: WikipediaTitleQueryFactory.create(
                random: [
                    WikipediaTitleFactory.create(
                        title: startTitle
                    ),
                    WikipediaTitleFactory.create(
                        title: "fake-title-2"
                    )
                ]
            )
        )
        
        given(mockWikipediaRepository.getTitles()).willReturn(
            Future(value: wikipediaTitleResponce)
        )
        
        _ = subject.view
        
        let startLabel = subject.view.findLabel(withId: R.id.MainView_startTitle.rawValue)
        let goalLabel = subject.view.findLabel(withId: R.id.MainView_goalTitle.rawValue)
        expect(startLabel?.text).toEventually(equal(startTitle))
        expect(goalLabel?.text).to(equal("fake-title-2"))
        
        
        let gameStartButton = subject.view.findButton(withId: R.id.MainView_gameStartButton.rawValue)
        
        gameStartButton?.tap()
        subject.view.layoutIfNeeded()

        expect(self.routerSpy.pushViewController_args.viewController).to(beAKindOf(WikipediaGameViewController.self))
    }
}
