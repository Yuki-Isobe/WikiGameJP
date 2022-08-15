import Foundation
import UIKit
import BrightFutures

class WikipediaGameViewController: UIViewController {
    private let router: Router
    private let wikipediaRepository: WikipediaRepository
    
    private let titleStart: String
    private let titleGoal: String
    
    init(
        router: Router,
        wikipediaRepository: WikipediaRepository = WikipediaRepositoryImpl(),
        titleStart: String,
        titleGoal: String
    ) {
        self.router = router
        self.wikipediaRepository = wikipediaRepository
        self.titleStart = titleStart
        self.titleGoal = titleGoal
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        print("start: \(titleStart), goal: \(titleGoal)")
        wikipediaRepository.getInfo(title: titleStart)
        
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
