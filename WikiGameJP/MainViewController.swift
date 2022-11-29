import BrightFutures
import UIKit
import SwiftUI

class MainViewController: UIViewController {
    private let futureExecuteContext: ExecutionContext
    
    private let router: Router
    private let wikipediaRepository: WikipediaRepository
    
    private var titles: [String] = []

    private let startLabel = UILabel()
    private let startSubLabel = UILabel()
    private let goalLabel = UILabel()
    private let goalSubLabel = UILabel()
    
    private let titleSwapButton = UIButton()
    private let titleReloadButton = UIButton()
    
    private let gameStartButton = UIButton()
    
    init(
        router: Router,
        wikipediaRepository: WikipediaRepository = WikipediaRepositoryImpl(),
        futureExecutionContext: @escaping ExecutionContext = defaultContext()
    ) {
        self.router = router
        self.wikipediaRepository = wikipediaRepository
        self.futureExecuteContext = futureExecutionContext
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getTitle()
        
        addSubviews()
        configSubviews()
        constraintSubviews()
        styleSubviews()
    }
    
    private func getTitle() {
        wikipediaRepository.getTitles()
            .onSuccess(futureExecuteContext) { [weak self] result in
                guard let weakSelf = self else {
                    return
                }
                
                let resultTitles = result.query.random
                weakSelf.startLabel.text = resultTitles[0].title
                weakSelf.goalLabel.text = resultTitles[1].title
            }
            .onFailure(callback: { error in
                print("\(error.localizedDescription)")
            })
    }
    
    private func addSubviews() {
        view.addSubview(startLabel)
        view.addSubview(startSubLabel)
        view.addSubview(goalLabel)
        view.addSubview(goalSubLabel)
        
        view.addSubview(titleSwapButton)
        view.addSubview(titleReloadButton)
        
        view.addSubview(gameStartButton)
    }
    
    private func configSubviews() {
        navigationController?.navigationBar.barTintColor = .blue
        
        startLabel.accessibilityIdentifier = R.id.MainView_startTitle.rawValue
        startLabel.textColor = UIColor(red: 0.52, green: 0.73, blue: 0.40, alpha: 1.00)
        startLabel.textAlignment = .center
        
        startSubLabel.textAlignment = .center
        startSubLabel.textColor = UIColor(red: 0.24, green: 0.34, blue: 0.36, alpha: 1.00)
        startSubLabel.text = "から"
        
        goalLabel.accessibilityIdentifier = R.id.MainView_goalTitle.rawValue
        goalLabel.textAlignment = .center
        
        goalSubLabel.textAlignment = .center
        goalSubLabel.text = "まで"
        
        titleSwapButton.accessibilityIdentifier = R.id.MainView_titleSwapButton.rawValue
        titleSwapButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        titleSwapButton.addTarget(self, action: #selector(tappedTitleSwapButton), for: .touchUpInside)
        titleSwapButton.layer.cornerRadius = 25
        
        titleReloadButton.accessibilityIdentifier = R.id.MainView_titleReloadButton.rawValue
        titleReloadButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        titleReloadButton.addTarget(self, action: #selector(tappedTitleReloadButton), for: .touchUpInside)
        titleReloadButton.layer.cornerRadius = 25
        
        gameStartButton.accessibilityIdentifier = R.id.MainView_gameStartButton.rawValue
        gameStartButton.addTarget(self, action: #selector(tappedGameStartButton), for: .touchUpInside)
        gameStartButton.layer.cornerRadius = 10
        gameStartButton.setTitle("ゲーム開始", for: .normal)
    }
    
    private func constraintSubviews() {
        startLabel.constrainTop(to: .Top, of: view.safeAreaLayoutGuide, constant: 20)
        startLabel.constrainRight(to: .Right, of: view, constant: -20)
        startLabel.constrainLeft(to: .Left, of: view, constant: 20)
        
        startSubLabel.constrainTop(to: .Bottom, of: startLabel, constant: 20)
        startSubLabel.constrainRight(to: .Right, of: view, constant: -20)
        startSubLabel.constrainLeft(to: .Left, of: view, constant: 10)

        goalLabel.constrainTop(to: .Bottom, of: startSubLabel, constant: 70)
        goalLabel.constrainRight(to: .Right, of: view, constant: -20)
        goalLabel.constrainLeft(to: .Left, of: view, constant: 20)
        
        goalSubLabel.constrainTop(to: .Bottom, of: goalLabel, constant: 20)
        goalSubLabel.constrainRight(to: .Right, of: view, constant: -20)
        goalSubLabel.constrainLeft(to: .Left, of: view, constant: 10)
        
        titleSwapButton.constrainHeight(constant: 50)
        titleSwapButton.constrainWidth(constant: 50)
        titleSwapButton.constrainTop(to: .Bottom, of: startSubLabel, constant: 10)
        titleSwapButton.constrainLeft(to: .Left, of: view, constant: 20)

        titleReloadButton.constrainHeight(constant: 50)
        titleReloadButton.constrainWidth(constant: 50)
        titleReloadButton.constrainTop(to: .Bottom, of: startSubLabel, constant: 10)
        titleReloadButton.constrainRight(to: .Right, of: view, constant: -20)

        gameStartButton.constrainTop(to: .Bottom, of: goalSubLabel, constant: 20)
        gameStartButton.constrainXCenter(to: .CenterXAnchor, of: view)
        gameStartButton.constrainWidth(constant: 175)
        gameStartButton.constrainHeight(constant: 75)
    }
    
    private func styleSubviews() {
        let mainFont = UIFont.systemFont(ofSize: 40, weight: .heavy)
        let subFont = UIFont.systemFont(ofSize: 25, weight: .heavy)
        let buttonFont = UIFont.systemFont(ofSize: 30, weight: .heavy)
        let buttonsTintColor = UIColor(red: 0.55, green: 0.57, blue: 0.55, alpha: 1.00)
        let buttonsBackgroundColor = UIColor(red: 0.90, green: 0.89, blue: 0.89, alpha: 1.00)
        
        startLabel.font = mainFont
        startLabel.textColor = primaryDark
        startLabel.adjustsFontSizeToFitWidth = true
        startLabel.minimumScaleFactor = 0.3
        startLabel.numberOfLines = 4
        
        startSubLabel.font = subFont
        startSubLabel.textColor = primaryBase

        goalLabel.font = mainFont
        goalLabel.textColor = primaryDark
        goalLabel.adjustsFontSizeToFitWidth = true
        goalLabel.minimumScaleFactor = 0.3
        goalLabel.numberOfLines = 4
        
        goalSubLabel.font = subFont
        goalSubLabel.textColor = primaryBase
        
        titleSwapButton.imageView?.tintColor = buttonsTintColor
        titleSwapButton.backgroundColor = buttonsBackgroundColor
        
        titleReloadButton.imageView?.tintColor = buttonsTintColor
        titleReloadButton.backgroundColor = buttonsBackgroundColor
        
        gameStartButton.titleLabel?.font = buttonFont
        gameStartButton.backgroundColor = primary
        gameStartButton.setTitleColor(secondaryBase, for: .normal)
    }
    
    @objc func tappedTitleSwapButton() {
        let tmpText = startLabel.text
        startLabel.text = goalLabel.text
        goalLabel.text = tmpText
    }
    
    @objc func tappedTitleReloadButton() {
        getTitle()
    }
    
    @objc func tappedGameStartButton() {
        if let nc = navigationController,
           let titleStart = startLabel.text,
           let titleGoal = goalLabel.text
        {
            router.pushViewController(
                WikipediaGameViewController(
                    router: router,
                    titleStart: titleStart,
                    titleGoal: titleGoal
                )
                , on: nc)
        }
    }
}
