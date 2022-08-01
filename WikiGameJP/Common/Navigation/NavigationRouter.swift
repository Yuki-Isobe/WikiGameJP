import UIKit

class NavigationRouter: Router {
    private(set) var isAnimatingTransitions: Bool
    private(set) var rootNavigationController: AppNavigationController?

    init(willAnimateTransitions: Bool)
    {
        isAnimatingTransitions = willAnimateTransitions
    }

    func buildRootNavigationController(rootVC viewController: UIViewController) -> UINavigationController {
        rootNavigationController = AppNavigationController()

        rootNavigationController?.viewControllers = [viewController]

        return rootNavigationController!
    }

    func pushViewController(
        _ viewController: UIViewController,
        on navigationController: UINavigationController
    ) {
        navigationController.pushViewController(
            viewController, animated: isAnimatingTransitions
        )
    }

    func popViewController(navigationController: UINavigationController?) {
        navigationController?.popViewController(animated: isAnimatingTransitions)
    }

    func popToRootViewController(navigationController: UINavigationController) {
        navigationController.popToRootViewController(animated: isAnimatingTransitions)
    }

    func dismiss(viewController: UIViewController, animated: Bool? = nil) {
        viewController.dismiss(animated: animated ?? isAnimatingTransitions, completion: nil)
    }
}
