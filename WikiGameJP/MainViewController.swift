import BrightFutures
import UIKit

class MainViewController: UIViewController {
    private let futureExecuteContext: ExecutionContext
    
    private let router: Router
    private let wikipediaRepository: WikipediaRepository
    
    private var titles: [String] = []
    
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
        view.addSubview(startLabel)
        view.addSubview(goalLabel)
        
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
        startLabel.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        startLabel.constrainLeft(to: .Left, of: view)
        startLabel.constrainRight(to: .Right, of: view)
        
        titleSwapButton.constrainTop(to: .Bottom, of: startLabel)
        titleSwapButton.constrainBottom(to: .Top, of: goalLabel)
        titleSwapButton.constrainLeft(to: .Left, of: view)

        titleReloadButton.constrainTop(to: .Bottom, of: startLabel)
        titleReloadButton.constrainBottom(to: .Top, of: goalLabel)
        titleReloadButton.constrainRight(to: .Right, of: view)
        
        goalLabel.constrainTop(to: .Bottom, of: titleSwapButton)
        goalLabel.constrainLeft(to: .Left, of: view)
        goalLabel.constrainRight(to: .Right, of: view)
        
        gameStartButton.constrainTop(to: .Bottom, of: goalLabel)
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

