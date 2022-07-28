import BrightFutures
import UIKit

class MainViewController: UIViewController {
    private let futureExecuteContext: ExecutionContext
    private let wikipediaRepository: WikipediaRepository
    
    private var titles: [String] = []
    
    private let startLabel = UILabel()
    private let goalLabel = UILabel()
    
    private let titleSwapButton = UIButton()
    
    init(
        wikipediaRepository: WikipediaRepository = WikipediaRepositoryImpl(),
        futureExecutionContext: @escaping ExecutionContext = defaultContext()
    ) {
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
    }
    
    private func configSubviews() {
        startLabel.accessibilityIdentifier = R.id.MainView_startTitle.rawValue
        goalLabel.accessibilityIdentifier = R.id.MainView_goalTitle.rawValue
        
        titleSwapButton.accessibilityIdentifier = R.id.MainView_titleSwapButton.rawValue
        titleSwapButton.backgroundColor = .gray
        titleSwapButton.addTarget(self, action: #selector(tappedTitleSwapButton), for: .touchUpInside)
    }
    
    private func constraintSubviews() {
        startLabel.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        startLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        
        goalLabel.constrainTop(to: .Bottom, of: startLabel)
        goalLabel.constrainXCenter(to: .CenterXAnchor, of: view)
        
        titleSwapButton.constrainTop(to: .Bottom, of: goalLabel)
        titleSwapButton.constrainXCenter(to: .CenterXAnchor, of: view)
    }
    
    private func styleSubviews() {
    }
    
    @objc func tappedTitleSwapButton() {
        let tmpText = startLabel.text
        startLabel.text = goalLabel.text
        goalLabel.text = tmpText
    }
}

