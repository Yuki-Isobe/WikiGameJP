import Foundation
import UIKit

class WikipediaGoalViewController: UIViewController {
    private let router: Router
    private let score: Int
    
    init(
        router: Router,
        score: Int
    ) {
        self.router = router
        self.score = score

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configSubviews()
        constraintSubviews()
        styleSubviews()
    }
    
    private func addSubviews() {
        
    }
    
    private func configSubviews() {
        
    }
    
    private func constraintSubviews() {
        
    }
    
    private func styleSubviews() {
        
    }
}
