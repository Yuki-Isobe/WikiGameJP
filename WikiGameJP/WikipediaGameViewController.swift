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
    private var count: Int = 0
    
    private let startLabel = UILabel()
    private let arrowLabel = UILabel()
    private let countLabel = UILabel()
    private let goalLabel = UILabel()
    
    private let indicator = UIActivityIndicatorView()
    
    private let headerView = UIView()
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
                
        getPageInfo(targetTitle: titleStart, isFirst: true)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(startLabel)
        headerView.addSubview(arrowLabel)
        headerView.addSubview(countLabel)
        headerView.addSubview(goalLabel)
        view.addSubview(webView)
        view.addSubview(indicator)
    }
    
    private func configSubviews() {
        startLabel.accessibilityIdentifier = R.id.GameView_startTitle.rawValue
        startLabel.textAlignment = .center
        startLabel.text = titleStart
        
        arrowLabel.textAlignment = .center
        arrowLabel.text = "↓"
        
        
        countLabel.accessibilityIdentifier = R.id.GameView_count.rawValue
        countLabel.textAlignment = .center
        setCount()
        
        goalLabel.accessibilityIdentifier = R.id.GameView_goalTitle.rawValue
        goalLabel.textAlignment = .center
        goalLabel.text = titleGoal
        
    }
    
    private func constraintSubviews() {
        headerView.constrainTop(to: .Top, of: view)
        headerView.constrainLeft(to: .Left, of: view)
        headerView.constrainRight(to: .Right, of: view)
        
        startLabel.constrainLeft(to: .Left, of: headerView, constant: 20)
        startLabel.constrainRight(to: .Right, of: headerView, constant: -20)
        startLabel.constrainBottom(to: .Top, of: arrowLabel, constant: -5)
        
        arrowLabel.constrainYCenter(to: .CenterYAnchor, of: headerView, constant: 20)
        arrowLabel.constrainLeft(to: .Left, of: headerView, constant: 20)
        
        countLabel.constrainYCenter(to: .CenterYAnchor, of: headerView, constant: 20)
        countLabel.constrainRight(to: .Right, of: headerView, constant: -20)
        
        goalLabel.constrainTop(to: .Bottom, of: arrowLabel, constant: 5)
        goalLabel.constrainBottom(to: .Bottom, of: headerView, constant: -10)
        goalLabel.constrainLeft(to: .Left, of: headerView, constant: 20)
        goalLabel.constrainRight(to: .Right, of: headerView, constant: -20)
        
        webView.constrainTop(to: .Bottom, of: headerView, constant: 1)
        webView.constrainBottom(to: .Bottom, of: view)
        webView.constrainLeft(to: .Left, of: view)
        webView.constrainRight(to: .Right, of: view)
        
        indicator.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        indicator.constrainBottom(to: .Bottom, of: view)
        indicator.constrainRight(to: .Right, of: view)
        indicator.constrainLeft(to: .Left, of: view)
    }
    
    private func styleSubviews() {
        let headerColor = UIColor(red: 0.52, green: 0.73, blue: 0.40, alpha: 1.00)
        let labelFont = UIFont.systemFont(ofSize: 20, weight: .heavy)
        let labelColor = UIColor.white
        
        headerView.backgroundColor = headerColor
        
        startLabel.font = labelFont
        startLabel.textColor = labelColor
        startLabel.adjustsFontSizeToFitWidth = true
        startLabel.minimumScaleFactor = 0.2
        startLabel.numberOfLines = 3
        startLabel.textAlignment = .left
        
        arrowLabel.font = labelFont
        arrowLabel.textColor = labelColor
        
        countLabel.font = labelFont
        countLabel.textColor = labelColor

        goalLabel.font = labelFont
        goalLabel.textColor = labelColor
        goalLabel.adjustsFontSizeToFitWidth = true
        goalLabel.minimumScaleFactor = 0.2
        goalLabel.numberOfLines = 3
        goalLabel.textAlignment = .left

    }
    
    private func getPageInfo(targetTitle: String, isFirst: Bool = false) {
        indicator.startAnimating()
        wikipediaRepository.getPageInfo(title: targetTitle)
            .onSuccess(futureExecuteContext) { [weak self] result in
                guard let weakSelf = self else {
                    return
                }
                let page = result.query.pages.first!
                let content = page.value.revisions.first!.content
                weakSelf.webView.loadHTMLString(content, baseURL: nil)
                
                if !isFirst {
                    weakSelf.addCount()
                }
            }
            .onFailure(callback: { error in
                print("\(error.localizedDescription)")
            })
            .onComplete(futureExecuteContext) { [weak self] _ in
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.indicator.stopAnimating()
            }
    }
    
    private func addCount() {
        count += 1
         setCount()
    }
    
    private func setCount() {
        countLabel.text = "Score: \(count)"
    }
}

extension WikipediaGameViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if url.absoluteString == "about:blank" {
            decisionHandler(.allow)
            return
        }
        
        let targetUrl = "/wiki/"
        if url.absoluteString.hasPrefix(targetUrl){
            let targetTitle = String(url.absoluteString.dropFirst(targetUrl.count))

            getPageInfo(targetTitle: targetTitle)
        }
            decisionHandler(.cancel)
        
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
