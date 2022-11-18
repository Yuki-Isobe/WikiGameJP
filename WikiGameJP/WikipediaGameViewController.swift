import Foundation
import UIKit
import WebKit
import BrightFutures

class WikipediaGameViewController: UIViewController {
    private let futureExecuteContext: ExecutionContext

    private let router: Router
    private let wikipediaRepository: WikipediaRepository
    
    private let startTitle: String
    private let goalTitle: String
    private var count: Int = 0
    
    private let currentLabel = UILabel()
    private let startLabel = UILabel()
    private let arrowLabel = UILabel()
    private let scoreLabel = UILabel()
    private let countLabel = UILabel()
    private let goalLabel = UILabel()
    
    private let indicator = UIActivityIndicatorView()
    
    private let headerView = UIView()
    private let footerView = UIView()
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

        self.startTitle = titleStart
        self.goalTitle = titleGoal
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        addSubviews()
        configSubviews()
        constraintSubviews()
        styleSubviews()
                
        getPageInfo(targetTitle: startTitle, isFirst: true)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(currentLabel)
        view.addSubview(webView)
        view.addSubview(footerView)
        footerView.addSubview(startLabel)
        footerView.addSubview(arrowLabel)
        footerView.addSubview(scoreLabel)
        footerView.addSubview(countLabel)
        footerView.addSubview(goalLabel)
        view.addSubview(indicator)
        
    }
    
    private func configSubviews() {
        view.backgroundColor = .white
        
        currentLabel.accessibilityIdentifier = R.id.GameView_currentTitle.rawValue
        
        startLabel.accessibilityIdentifier = R.id.GameView_startTitle.rawValue
        startLabel.textAlignment = .center
        startLabel.text = startTitle
        
        arrowLabel.textAlignment = .center
        arrowLabel.text = "↓"
        
        scoreLabel.textAlignment = .center
        scoreLabel.text = "Score:"
        
        countLabel.accessibilityIdentifier = R.id.GameView_count.rawValue
        countLabel.textAlignment = .center
        setCount()
        
        goalLabel.accessibilityIdentifier = R.id.GameView_goalTitle.rawValue
        goalLabel.textAlignment = .center
        goalLabel.text = goalTitle
        
    }
    
    private func constraintSubviews() {
        headerView.constrainTop(to: .Top, of: view)
        headerView.constrainBottom(to: .Top, of: webView)
        headerView.constrainLeft(to: .Left, of: view)
        headerView.constrainRight(to: .Right, of: view)
        
        currentLabel.constrainTop(to: .Top, of: headerView, constant: 50)
        currentLabel.constrainBottom(to: .Bottom, of: headerView, constant: -10)
        currentLabel.constrainXCenter(to: .CenterXAnchor, of: headerView)
        
        webView.constrainTop(to: .Bottom, of: headerView)
        webView.constrainBottom(to: .Top, of: footerView)
        webView.constrainLeft(to: .Left, of: view)
        webView.constrainRight(to: .Right, of: view)
        
        footerView.constrainTop(to: .Bottom, of: webView)
        footerView.constrainBottom(to: .Bottom, of: view)
        footerView.constrainLeft(to: .Left, of: view)
        footerView.constrainRight(to: .Right, of: view)

        startLabel.constrainTop(to: .Top, of: footerView, constant: 10)
        startLabel.constrainLeft(to: .Left, of: footerView, constant: 20)
        startLabel.constrainRight(to: .Right, of: footerView, constant: -20)

        arrowLabel.constrainTop(to: .Bottom, of: startLabel, constant: 10)
        arrowLabel.constrainBottom(to: .Top, of: goalLabel, constant: -10)
        arrowLabel.constrainLeft(to: .Left, of: footerView, constant: 20)

        countLabel.constrainTop(to: .Bottom, of: startLabel, constant: 10)
        countLabel.constrainBottom(to: .Top, of: goalLabel, constant: -10)
        countLabel.constrainRight(to: .Right, of: footerView, constant: -20)

        scoreLabel.constrainTop(to: .Bottom, of: startLabel, constant: 10)
        scoreLabel.constrainBottom(to: .Top, of: goalLabel, constant: -10)
        scoreLabel.constrainRight(to: .Left, of: countLabel, constant: -10)

        goalLabel.constrainTop(to: .Bottom, of: arrowLabel)
        goalLabel.constrainBottom(to: .Bottom, of: footerView, constant: -20)
        goalLabel.constrainLeft(to: .Left, of: footerView, constant: 20)
        goalLabel.constrainRight(to: .Right, of: footerView, constant: -20)

        indicator.constrainTop(to: .Top, of: view.safeAreaLayoutGuide)
        indicator.constrainBottom(to: .Bottom, of: view)
        indicator.constrainRight(to: .Right, of: view)
        indicator.constrainLeft(to: .Left, of: view)
    }
    
    private func styleSubviews() {
        let labelFont = UIFont.systemFont(ofSize: 20, weight: .heavy)
        
        headerView.backgroundColor = primary
        footerView.backgroundColor = primary
        
        currentLabel.font = labelFont
        currentLabel.textColor = secondaryBase
        currentLabel.adjustsFontSizeToFitWidth = true
        currentLabel.minimumScaleFactor = 0.2
        currentLabel.numberOfLines = 3
        
        startLabel.font = labelFont
        startLabel.textColor = secondaryBase
        startLabel.adjustsFontSizeToFitWidth = true
        startLabel.minimumScaleFactor = 0.2
        startLabel.numberOfLines = 3
        startLabel.textAlignment = .left
        
        arrowLabel.font = labelFont
        arrowLabel.textColor = secondaryBase
        
        scoreLabel.font = labelFont
        scoreLabel.textColor = secondaryBase
        
        countLabel.font = labelFont
        countLabel.textColor = secondaryBase

        goalLabel.font = labelFont
        goalLabel.textColor = secondaryBase
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
                let title = page.value.title
                let content = page.value.revisions.first!.content
                weakSelf.webView.loadHTMLString(content, baseURL: nil)
                
                weakSelf.currentLabel.text = title
                
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
        
        if count > 3 {
            sendGoal()
            return
        }
        
        setCount()
    }
    
    private func setCount() {
        countLabel.text = "\(count)"
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
            
            guard let decodedTitle = targetTitle.removingPercentEncoding else {
                decisionHandler(.cancel)
                return
            }
            
//            if decodedTitle == goalTitle {
            if decodedTitle != goalTitle {
                if let nc = navigationController
                {
                    router.pushViewController(
                        WikipediaGoalViewController(
                            router: router,
                            startTitle: startTitle,
                            goalTitle: goalTitle,
                            score: count
                        )
                        , on: nc)
                }
            } else {
                getPageInfo(targetTitle: decodedTitle)
            }
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
    
    private func sendGoal() {
        if let nc = navigationController
        {
            router.pushViewController(
                WikipediaGoalViewController(
                    router: router,
                    startTitle: startTitle,
                    goalTitle: goalTitle,
                    score: count
                )
                , on: nc)
        }
    }
}
