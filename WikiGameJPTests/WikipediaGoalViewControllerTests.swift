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
    
    func test_viewDidLoad() {
        let score = 123
        let startTitle = "fake-start-title"
        let goalTitle = "fake-goal-title"
        
        initSubject(
            score: score,
            startTitle: startTitle,
            goaltitle: goalTitle
        )

        _ = subject.view
        subject.view.layoutIfNeeded()
        
        let startLabel = subject.view.findLabel(withId: R.id.GoalView_startTitle.rawValue)
        expect(startLabel?.text).toEventually(equal(startTitle))
        
        let goalLabel = subject.view.findLabel(withId: R.id.GoalView_goalTitle.rawValue)
        expect(goalLabel?.text).to(equal(goalTitle))
        
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
    
    private func initSubject(
        score: Int = 0,
        startTitle: String = "",
        goaltitle: String = ""
    ) {
        subject = WikipediaGoalViewController(
            router: routerSpy,
            startTitle: startTitle,
            goalTitle: goaltitle,
            score: score
        )

        navigationController.viewControllers = [
            subject
        ]
    }
}
