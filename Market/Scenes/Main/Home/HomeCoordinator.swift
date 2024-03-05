//
//  HomeCoordinator.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

@MainActor
protocol HomeCoordinating: MainTabBarChildCoordinating {
//    func showDetail(index: Int)
//    func childDidFinish(_ child: Coordinator?)
}

final class HomeCoordinator: NSObject, HomeCoordinating {

    weak var parentCoordinator: MainTabBarCoordinating?

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    @Injected private var store: AppStore
    @Injected private var coordinatorFactory: CoordinatorFactory
    @Injected private var viewControllerFactory: ViewControllerFactory

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(animated: Bool) {
//        navigationController.delegate = self
        let viewController = viewControllerFactory.homeVC()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: animated)
    }

//    func showDetail(index: Int) {
//        let child = coordinatorFactory.detailCoordinator(navigationController, index: index)
//        child.parentCoordinator = self
//        childCoordinators.append(child)
//        child.start(animated: true)
//    }
//
//    func childDidFinish(_ child: Coordinator?) {
//        for (index, coordinator) in childCoordinators.enumerated() {
//            if coordinator === child {
//                childCoordinators.remove(at: index)
//                break
//            }
//        }
//    }
}

// extension HomeCoordinator: UINavigationControllerDelegate {
//    func navigationController(
//        _ navigationController: UINavigationController,
//        didShow viewController: UIViewController,
//        animated: Bool
//    ) {
//        guard let fromViewController = navigationController
//            .transitionCoordinator?.viewController(forKey: .from)
//        else { return }
//
//        guard !navigationController.viewControllers.contains(fromViewController) else {
//            return
//        }
//
//        guard let detailViewController = fromViewController as? DetailViewController else {
//            return
//        }
//        childDidFinish(detailViewController.coordinator)
//    }
// }
