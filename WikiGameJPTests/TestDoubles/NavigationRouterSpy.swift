@testable import WikiGameJP
import UIKit

class NavigationRouterSpy: Router {
    var pushViewController_args: (viewController: UIViewController?, navigationController: UINavigationController?)

    func pushViewController(_ viewController: UIViewController, on navigationController: UINavigationController, animated: Bool) {
        pushViewController_args.viewController = viewController
        pushViewController_args.navigationController = navigationController
    }

    func pushViewController(_ controller: UIViewController, on: UINavigationController) {
        pushViewController_args.viewController = controller
        pushViewController_args.navigationController = on
    }

    func popViewController(navigationController: UINavigationController?) {
    }
    
    private(set) var popToRootViewControllerCallCount = 0
    
    func popToRootViewController(navigationController: UINavigationController) {
        popToRootViewControllerCallCount += 1
    }

    var dismissModal_args: UIViewController?

    func dismissModal(viewController: UIViewController) {
        dismissModal_args = viewController
    }

    private(set) var isAnimatingTransitions: Bool = false

    func buildRootNavigationController(rootVC viewController: UIViewController) -> UINavigationController {
        fatalError("buildRootNavigationController(rootVC:) has not been implemented")
    }

    private(set) var present_args: (viewController: UIViewController?, fromViewController: UIViewController?)

    func present(viewController: UIViewController, fromViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        present_args.viewController = viewController
        present_args.fromViewController = fromViewController
    }
}
