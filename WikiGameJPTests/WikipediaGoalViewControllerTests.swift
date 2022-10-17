import XCTest
import Nimble
@testable import WikiGameJP
import CloudKit

class WikipediaGoalViewControllerTests: XCTestCase {
    var subject: WikipediaGoalViewController!
    
    private var routerSpy: NavigationRouterSpy!
    
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
    
    private func initSubject(score: Int) {
        subject = WikipediaGoalViewController(
            router: routerSpy,
            score: score
        )
    }
}
