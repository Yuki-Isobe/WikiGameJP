import Foundation
import UIKit

class WikipediaGoalViewController: UIViewController {
    private let router: Router
    private let score: Int
    
    private let scoreLabel = UILabel()
    
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
        
        self.navigationItem.hidesBackButton = true
        
        
        addSubviews()
        configSubviews()
        constraintSubviews()
        styleSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(scoreLabel)
    }
    
    private func configSubviews() {
        view.backgroundColor = .white
        
        scoreLabel.accessibilityIdentifier = R.id.GoalView_score.rawValue
        scoreLabel.text = String(score)
    }
    
    private func constraintSubviews() {
        scoreLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        scoreLabel.constrainYCenter(to: .CenterYAnchor, of: view)
    }
    
    private func styleSubviews() {
        let mainFont = UIFont.systemFont(ofSize: 40, weight: .heavy)
        let mainColor = UIColor(red: 0.52, green: 0.73, blue: 0.40, alpha: 1.00)
        
        scoreLabel.font = mainFont
        scoreLabel.textColor = mainColor
    }
}
