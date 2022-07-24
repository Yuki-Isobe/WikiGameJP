import UIKit

class MainViewController: UIViewController {
    private let wikipediaRepository: WikipediaRepository
    
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
        view.backgroundColor = .cyan
        
        let test = wikipediaRepository.getTitles()
    }
}

