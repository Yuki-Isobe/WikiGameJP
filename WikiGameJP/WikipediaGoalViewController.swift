import Foundation
import UIKit

class WikipediaGoalViewController: UIViewController {
    private let router: Router
    private let score: Int
    private let startTitle: String
    private let goalTitle: String
    
    private let headerLabel = UILabel()
    private let resultView = UIView()
    private let startLabel = UILabel()
    private let startSubLabel = UILabel()
    private let goalLabel = UILabel()
    private let goalSubLabel = UILabel()
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
        view.addSubview(resultView)
        resultView.addSubview(scoreView)
        scoreView.addSubview(scoreHeaderLabel)
        scoreView.addSubview(scoreLabel)
        resultView.addSubview(startLabel)
        resultView.addSubview(startSubLabel)
        resultView.addSubview(goalLabel)
        resultView.addSubview(goalSubLabel)
        view.addSubview(retryButton)
    }
    
    private func configSubviews() {
        view.backgroundColor = .white
        
        headerLabel.text = "GOAL!!!"
        
        resultView.layer.cornerRadius = 10
        
        scoreHeaderLabel.text = "Score:"
        
        scoreLabel.accessibilityIdentifier = R.id.GoalView_score.rawValue
        scoreLabel.text = String(score)
        
        startLabel.accessibilityIdentifier = R.id.GoalView_startTitle.rawValue
        startLabel.textAlignment = .center
        startLabel.text = startTitle
        
        startSubLabel.text = "から"
        
        goalLabel.accessibilityIdentifier = R.id.GoalView_goalTitle.rawValue
        goalLabel.textAlignment = .center
        goalLabel.text = goalTitle
        
        goalSubLabel.text = "まで"
        
        retryButton.accessibilityIdentifier = R.id.GoalView_retryButton.rawValue
        retryButton.setTitle("もう一度遊ぶ", for: .normal)
        retryButton.addTarget(self, action: #selector(tappedRetryButton), for: .touchUpInside)
        retryButton.layer.cornerRadius = 10
    }
    
    private func constraintSubviews() {
        headerLabel.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        headerLabel.constrainBottom(to: .Top, of: resultView, constant: -20)
        headerLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        
        resultView.constrainTop(to: .Bottom, of: headerLabel)
        resultView.constrainBottom(to: .Top, of: retryButton, constant: -20)
        resultView.constrainRight(to: .Right, of: view, constant: -10)
        resultView.constrainLeft(to: .Left, of: view, constant: 10)
        
        scoreView.constrainTop(to: .Top, of: resultView, constant: 10)
        scoreView.constrainBottom(to: .Top, of: startLabel)
        scoreView.constrainXCenter(to: .CenterXAnchor, of: view)
        
        scoreHeaderLabel.constrainTop(to: .Top, of: scoreView)
        scoreHeaderLabel.constrainBottom(to: .Bottom, of: scoreView)
        scoreHeaderLabel.constrainLeft(to: .Left, of: scoreView)
        scoreHeaderLabel.constrainRight(to: .Left, of: scoreLabel)
        
        scoreLabel.constrainTop(to: .Top, of: scoreView)
        scoreLabel.constrainBottom(to: .Bottom, of: scoreView)
        scoreLabel.constrainRight(to: .Right, of: scoreView)
        scoreLabel.constrainLeft(to: .Right, of: scoreHeaderLabel)
        
        startLabel.constrainTop(to: .Bottom, of: scoreView)
        startLabel.constrainBottom(to: .Top, of: startSubLabel, constant: -10)
        startLabel.constrainRight(to: .Right, of: resultView, constant: -20)
        startLabel.constrainLeft(to: .Left, of: resultView, constant: 20)
        
        startSubLabel.constrainTop(to: .Bottom, of: startLabel, constant: 10)
        startSubLabel.constrainBottom(to: .Top, of: goalLabel, constant: -10)
        startSubLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        
        goalLabel.constrainTop(to: .Bottom, of: startSubLabel)
        goalLabel.constrainBottom(to: .Top, of: goalSubLabel, constant: -10)
        goalLabel.constrainRight(to: .Right, of: resultView, constant: -10)
        goalLabel.constrainLeft(to: .Left, of: resultView, constant: 10)
        
        goalSubLabel.constrainTop(to: .Bottom, of: goalLabel, constant: 10)
        goalSubLabel.constrainBottom(to: .Bottom, of: resultView, constant: -20)
        goalSubLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        
        retryButton.constrainTop(to: .Bottom, of: resultView)
        retryButton.constrainWidth(constant: 185)
        retryButton.constrainHeight(constant: 75)
        retryButton.constrainXCenter(to: .CenterXAnchor, of: view)
    }
    
    private func styleSubviews() {
        let mainFont = UIFont.systemFont(ofSize: 40, weight: .heavy)
        let subFont = UIFont.systemFont(ofSize: 20, weight: .heavy)
        let buttonFont = UIFont.systemFont(ofSize: 30, weight: .heavy)
        
        headerLabel.font = mainFont
        headerLabel.textColor = secondaryLight
        
        resultView.backgroundColor = primaryLight
        
        startLabel.font = mainFont
        startLabel.textColor = secondaryBase
        startLabel.adjustsFontSizeToFitWidth = true
        startLabel.minimumScaleFactor = 0.3
        startLabel.numberOfLines = 4
        
        startSubLabel.font = subFont
        startSubLabel.textColor = secondaryBase
        
        goalLabel.font = mainFont
        goalLabel.textColor = secondaryBase
        goalLabel.adjustsFontSizeToFitWidth = true
        goalLabel.minimumScaleFactor = 0.3
        goalLabel.numberOfLines = 4
        
        goalSubLabel.font = subFont
        goalSubLabel.textColor = secondaryBase
        
        scoreHeaderLabel.font = subFont
        scoreHeaderLabel.textColor = secondaryBase
        
        scoreLabel.font = mainFont
        scoreLabel.textColor = secondaryBase
        
        retryButton.titleLabel?.font = buttonFont
        retryButton.backgroundColor = primary
        retryButton.setTitleColor(secondaryBase, for: .normal)
    }
    
    @objc func tappedRetryButton() {
        if let nc = navigationController {
            router.popToRootViewController(navigationController: nc)
        }
    }
}
