import XCTest
import Nimble
@testable import WikiGameJP

class WikipediaUrlGeneratorTests: XCTestCase {
    var subject: WikipediaUrlGeneratorImpl!
    
    override func setUp() {
        super.setUp()
        
        subject = WikipediaUrlGeneratorImpl()
    }
    
    func test_generateGetTitleUrl() {
        let actual = subject.generateGetTitleUrl()
        let expectUrl = "https://ja.wikipedia.org/w/api.php?action=query&format=json&list=random&rnnamespace=0&rnlimit=2"
        
        expect(actual).to(equal(expectUrl))
    }
    
    func test_generateGetPageInfoUrl() {
        let title = "fake-title"
        
        let actual = subject.generateGetPageInfoUrl(title: title)
        let expectUrl = "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&rvprop=content&rvparse=1&titles=fake-title&redirects"
        
        expect(actual).to(equal(expectUrl))
    }
    
    func test_generateGetTitleInfoUrl() {
        let startTitle = "fake-start-title"
        let goalTitle = "fake-goal-title"
        
        let actual = subject.generateGetTitleInfoUrl(startTitle: startTitle, goalTitle: goalTitle)
        let expectUrl = "https://ja.wikipedia.org/w/api.php?action=query&format=json&titles=fake-start-title|fake-goal-title"
        
        expect(actual).to(equal(expectUrl))
    }
}
