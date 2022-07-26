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
}
