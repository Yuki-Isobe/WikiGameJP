import Foundation
import UIKit
import WebKit
import BrightFutures

class WikipediaGameViewController: UIViewController {
    private let futureExecuteContext: ExecutionContext

    private let router: Router
    private let wikipediaRepository: WikipediaRepository
    
    private let titleStart: String
    private let titleGoal: String
    
    private let startLabel = UILabel()
    private let goalLabel = UILabel()
    private var webView: WKWebView!
    
    init(
        router: Router,
        wikipediaRepository: WikipediaRepository = WikipediaRepositoryImpl(),
        futureExecutionContext: @escaping ExecutionContext = defaultContext(),
        titleStart: String,
        titleGoal: String
    ) {
        self.router = router
        self.wikipediaRepository = wikipediaRepository
        self.futureExecuteContext = futureExecutionContext

        self.titleStart = titleStart
        self.titleGoal = titleGoal
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        addSubviews()
        configSubviews()
        constraintSubviews()
        styleSubviews()
                
        getPageInfo(targetTitle: titleStart)
    }
    
    private func addSubviews() {
        view.addSubview(startLabel)
        view.addSubview(goalLabel)
        view.addSubview(webView)
    }
    
    private func configSubviews() {
        startLabel.accessibilityIdentifier = R.id.GameView_startTitle.rawValue
        startLabel.textAlignment = .center
        startLabel.text = titleStart
        
        goalLabel.accessibilityIdentifier = R.id.GameView_goalTitle.rawValue
        goalLabel.textAlignment = .center
        goalLabel.text = titleGoal
    }
    
    private func constraintSubviews() {
        webView.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        webView.constrainBottom(to: .Bottom, of: view)
        webView.constrainLeft(to: .Left, of: view)
        webView.constrainRight(to: .Right, of: view)
    }
    
    private func styleSubviews() {
    }
    
    private func getPageInfo(targetTitle: String) {
        wikipediaRepository.getPageInfo(title: targetTitle)
            .onSuccess(futureExecuteContext) { [weak self] result in
                guard let weakSelf = self else {
                    return
                }
                let page = result.query.pages.first!
                let content = page.value.revisions.first!.content
                weakSelf.webView.loadHTMLString(content, baseURL: nil)
            }
            .onFailure(callback: { error in
                print("\(error.localizedDescription)")
            })
    }
}

extension WikipediaGameViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("Link!! Link!!")
        let url = navigationAction.request.url
//        print(url ?? "blank link")
//
//        if url!.hasPrefix("/wiki/") {
//            print("wiki!!")
//        }

        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
