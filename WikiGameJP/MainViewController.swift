import UIKit

class MainViewController: UIViewController {
    private let wikipediaRepository: WikipediaRepository
    
    private var titles: [String] = []
    
    private let startLabel = UILabel()
    private let goalLabel = UILabel()
    
    init(
        wikipediaRepository: WikipediaRepository = WikipediaRepositoryImpl()
    ) {
        self.wikipediaRepository = wikipediaRepository
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        titles = wikipediaRepository.getTitles()
        
        addSubviews()
        configSubviews()
        constraintSubviews()
        styleSubviews()
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

