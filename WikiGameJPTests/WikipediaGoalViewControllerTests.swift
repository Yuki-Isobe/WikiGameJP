import XCTest
import Nimble
@testable import WikiGameJP

class WikipediaGoalViewControllerTests: XCTestCase {
    var subject: WikipediaGoalViewController!
    
    private var routerSpy: NavigationRouterSpy!
    
    override func setUp() {
        super.setUp()
        
        routerSpy = NavigationRouterSpy()
    }
    
    
    
    private func initSubject(score: Int) {
        subject = WikipediaGoalViewController(
            router: routerSpy,
            score: score
        )
    }
}
