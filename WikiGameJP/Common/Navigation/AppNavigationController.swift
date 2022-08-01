import UIKit

class AppNavigationController: UINavigationController {
    let router: Router

    init(
        router: Router = NavigationRouter(willAnimateTransitions: true)
    ) {
        self.router = router

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureSubviews()
        constraintSubviews()
    }

    private func addSubviews() {
        //noop
    }

    private func configureSubviews() {
        //noop
    }

    private func constraintSubviews() {
        //noop
    }
}
