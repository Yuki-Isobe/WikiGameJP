import BrightFutures
import UIKit
import SwiftUI

class MainViewController: UIViewController {
    private let futureExecuteContext: ExecutionContext
    
    private let router: Router
    private let wikipediaRepository: WikipediaRepository
    
    private var titles: [String] = []
    
    private let labelContainer = UIView()
    private let startLabel = UILabel()
    private let goalLabel = UILabel()
    
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
        view.addSubview(labelContainer)
        labelContainer.addSubview(startLabel)
        labelContainer.addSubview(goalLabel)
        
        view.addSubview(titleSwapButton)
        view.addSubview(titleReloadButton)
        
        view.addSubview(gameStartButton)
    }
    
    private func configSubviews() {
        startLabel.accessibilityIdentifier = R.id.MainView_startTitle.rawValue
        startLabel.textAlignment = .center
        
        goalLabel.accessibilityIdentifier = R.id.MainView_goalTitle.rawValue
        goalLabel.textAlignment = .center
        
        titleSwapButton.accessibilityIdentifier = R.id.MainView_titleSwapButton.rawValue
        titleSwapButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        titleSwapButton.addTarget(self, action: #selector(tappedTitleSwapButton), for: .touchUpInside)
        
        titleReloadButton.accessibilityIdentifier = R.id.MainView_titleReloadButton.rawValue
        titleReloadButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        titleReloadButton.addTarget(self, action: #selector(tappedTitleReloadButton), for: .touchUpInside)
        
        gameStartButton.accessibilityIdentifier = R.id.MainView_gameStartButton.rawValue
        gameStartButton.backgroundColor = .red
        gameStartButton.addTarget(self, action: #selector(tappedGameStartButton), for: .touchUpInside)
    }
    
    private func constraintSubviews() {
        labelContainer.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        labelContainer.constrainHeight(constant: 200)
        labelContainer.constrainLeft(to: .Left, of: view)
        labelContainer.constrainRight(to: .Right, of: view)
        
        startLabel.constrainTop(to: .Top, of: labelContainer)
        startLabel.constrainXCenter(to: .CenterXAnchor, of: labelContainer)
        
        goalLabel.constrainBottom(to: .Bottom, of: labelContainer)
        goalLabel.constrainXCenter(to: .CenterXAnchor, of: labelContainer)
        
        titleSwapButton.constrainTop(to: .Top, of: labelContainer)
        titleSwapButton.constrainBottom(to: .Bottom, of: labelContainer)
        titleSwapButton.constrainLeft(to: .Left, of: view, constant: 20)

        titleReloadButton.constrainTop(to: .Top, of: labelContainer)
        titleReloadButton.constrainBottom(to: .Bottom, of: labelContainer)
        titleReloadButton.constrainRight(to: .Right, of: view, constant: -20)

        gameStartButton.constrainTop(to: .Bottom, of: labelContainer, constant: 20)
        gameStartButton.constrainXCenter(to: .CenterXAnchor, of: view)
    }
    
    private func styleSubviews() {
        startLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        startLabel.numberOfLines = 0
        
        goalLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        goalLabel.numberOfLines = 0
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
        if let nc = navigationController {
            router.pushViewController(WikipediaGameViewController(router: router), on: nc)
        }
    }
}

