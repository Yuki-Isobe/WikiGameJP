import Foundation
import UIKit
import BrightFutures

class WikipediaGameViewController: UIViewController {
    private let router: Router
    
    init(
        router: Router
    ) {
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
}
