import UIKit

protocol Router {
    var isAnimatingTransitions: Bool { get }

    func buildRootNavigationController(rootVC viewController: UIViewController) -> UINavigationController

    // Navigation Controller
    func pushViewController(_: UIViewController, on: UINavigationController)
    func popViewController(navigationController: UINavigationController?)
    func popToRootViewController(navigationController: UINavigationController)

    // Modal
    func present(viewController: UIViewController, fromViewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(viewController: UIViewController, animated: Bool?)
    func dismissModal(viewController: UIViewController)
}

extension Router {
    func present(viewController: UIViewController, fromViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        fromViewController.present(viewController, animated: animated, completion: completion)
    }

    func dismiss(viewController: UIViewController, animated: Bool?) {
        dismiss(viewController: viewController, animated: animated ?? isAnimatingTransitions)
    }

    func dismissModal(viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else {
            viewController.dismiss(animated: isAnimatingTransitions)
            if let presentationController = viewController.presentationController {
                presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
            }
            return
        }

        navigationController.dismiss(animated: isAnimatingTransitions)
        if let presentationController = navigationController.presentationController {
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
    }
}
