import Foundation
import UIKit

class WikipediaGoalViewController: UIViewController {
    private let router: Router
    private let score: Int
    private let startTitle: String
    private let goalTitle: String
    
    private let headerLabel = UILabel()
    private let startLabel = UILabel()
    private let arrowLabel = UILabel()
    private let goalLabel = UILabel()
    private let scoreView = UIView()
    private let scoreHeaderLabel = UILabel()
    private let scoreLabel = UILabel()
    private let retryButton = UIButton()
    
    init(
        router: Router,
        startTitle: String,
        goalTitle: String,
        score: Int
    ) {
        self.router = router
        self.startTitle = startTitle
        self.goalTitle = goalTitle
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
        view.addSubview(headerLabel)
        view.addSubview(startLabel)
        view.addSubview(arrowLabel)
        view.addSubview(goalLabel)
        view.addSubview(scoreView)
        scoreView.addSubview(scoreHeaderLabel)
        scoreView.addSubview(scoreLabel)
        view.addSubview(retryButton)
    }
    
    private func configSubviews() {
        view.backgroundColor = .white
        
        headerLabel.text = "GOAL!!!"
        
        startLabel.accessibilityIdentifier = R.id.GoalView_startTitle.rawValue
        startLabel.textAlignment = .center
        startLabel.text = startTitle
        
        arrowLabel.text = "↓"
        
        goalLabel.accessibilityIdentifier = R.id.GoalView_goalTitle.rawValue
        goalLabel.textAlignment = .center
        goalLabel.text = goalTitle
        
        scoreHeaderLabel.text = "スコア:"
        
        scoreLabel.accessibilityIdentifier = R.id.GoalView_score.rawValue
        scoreLabel.text = String(score)
        
        retryButton.accessibilityIdentifier = R.id.GoalView_retryButton.rawValue
        retryButton.setTitle("もう一度遊ぶ", for: .normal)
        retryButton.addTarget(self, action: #selector(tappedRetryButton), for: .touchUpInside)
    }
    
    private func constraintSubviews() {
        headerLabel.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        headerLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        
        startLabel.constrainTop(to: .Bottom, of: headerLabel)
        startLabel.constrainRight(to: .Right, of: view, constant: -20)
        startLabel.constrainLeft(to: .Left, of: view, constant: 20)
        
        arrowLabel.constrainTop(to: .Bottom, of: startLabel, constant: 10)
        arrowLabel.constrainBottom(to: .Top, of: goalLabel, constant: -10)
        arrowLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        
        goalLabel.constrainTop(to: .Bottom, of: arrowLabel)
        goalLabel.constrainBottom(to: .Top, of: scoreView)
        goalLabel.constrainRight(to: .Right, of: view, constant: -20)
        goalLabel.constrainLeft(to: .Left, of: view, constant: 20)
        
        scoreView.constrainTop(to: .Bottom, of: goalLabel)
        scoreView.constrainBottom(to: .Top, of: retryButton)
        scoreView.constrainXCenter(to: .CenterXAnchor, of: view)
        
        scoreHeaderLabel.constrainTop(to: .Top, of: scoreView)
        scoreHeaderLabel.constrainBottom(to: .Bottom, of: scoreView)
        scoreHeaderLabel.constrainLeft(to: .Left, of: scoreView)
        scoreHeaderLabel.constrainRight(to: .Left, of: scoreLabel)
        
        scoreLabel.constrainTop(to: .Top, of: scoreView)
        scoreLabel.constrainBottom(to: .Bottom, of: scoreView)
        scoreLabel.constrainRight(to: .Right, of: scoreView)
        scoreLabel.constrainLeft(to: .Right, of: scoreHeaderLabel)
        
        retryButton.constrainTop(to: .Bottom, of: scoreView)
        retryButton.constrainHeight(constant: 50)
        retryButton.constrainXCenter(to: .CenterXAnchor, of: view)
    }
    
    private func styleSubviews() {
        let mainFont = UIFont.systemFont(ofSize: 40, weight: .heavy)
        let subFont = UIFont.systemFont(ofSize: 20, weight: .heavy)
        let mainColor = UIColor(red: 0.52, green: 0.73, blue: 0.40, alpha: 1.00)
        
        headerLabel.font = mainFont
        
        startLabel.font = mainFont
        startLabel.adjustsFontSizeToFitWidth = true
        startLabel.minimumScaleFactor = 0.3
        startLabel.numberOfLines = 4
        
        arrowLabel.font = subFont
        
        goalLabel.font = mainFont
        goalLabel.adjustsFontSizeToFitWidth = true
        goalLabel.minimumScaleFactor = 0.3
        goalLabel.numberOfLines = 4
        
        scoreLabel.font = mainFont
        scoreLabel.textColor = mainColor
        
        retryButton.backgroundColor = .blue
    }
    
    @objc func tappedRetryButton() {
        if let nc = navigationController {
            router.popToRootViewController(navigationController: nc)
        }
    }
}
