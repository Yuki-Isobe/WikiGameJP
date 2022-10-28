import XCTest
import Nimble
@testable import WikiGameJP
import CloudKit
import Mockingbird

class WikipediaGoalViewControllerTests: XCTestCase {
    var subject: WikipediaGoalViewController!
    
    private var routerSpy: NavigationRouterSpy!

    let navigationController = UINavigationController()
    
    override func setUp() {
        super.setUp()
        
        routerSpy = NavigationRouterSpy()
    }
    
    func test_viewDidLoad_showScore() {
        let score = 123
        
        initSubject(score: score)
        _ = subject.view
        
        let scoreLabel = subject.view.findLabel(withId: R.id.GoalView_score.rawValue)
        expect(scoreLabel?.text).to(equal(String(score)))
    }
    
    func test_tapRetryButton() {
        initSubject()

        _ = subject.view
        subject.view.layoutIfNeeded()
        
        let retryButton = subject.view.findButton(withId: R.id.GoalView_retryButton.rawValue)

        expect(self.routerSpy.popToRootViewControllerCallCount).to(equal(0))
        
        retryButton?.tap()
        
        expect(self.routerSpy.popToRootViewControllerCallCount).to(equal(1))
    }
    
    private func initSubject(score: Int = 0) {
        subject = WikipediaGoalViewController(
            router: routerSpy,
            score: score
        )

        navigationController.viewControllers = [
            subject
        ]
    }
}
