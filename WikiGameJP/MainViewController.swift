import BrightFutures
import UIKit

class MainViewController: UIViewController {
    private let futureExecuteContext: ExecutionContext
    private let wikipediaRepository: WikipediaRepository
    
    private var titles: [String] = []
    
    private let startLabel = UILabel()
    private let goalLabel = UILabel()
    
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
    }
    
    private func configSubviews() {
        startLabel.accessibilityIdentifier = R.id.MainView_startTitle.rawValue
        goalLabel.accessibilityIdentifier = R.id.MainView_goalTitle.rawValue
        
//        startLabel.text = titles[0]
//        goalLabel.text = titles[1]
    }
    
    private func constraintSubviews() {
        startLabel.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        goalLabel.constrainTop(to: .Bottom, of: startLabel)
    }
    
    private func styleSubviews() {
    }
}

