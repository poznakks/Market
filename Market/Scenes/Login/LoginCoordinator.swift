//
//  LoginCoordinator.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

@MainActor
protocol LoginCoordinating: Coordinator {
    var parentCoordinator: AppCoordinating? { get set }
    func logIn()
}

final class LoginCoordinator: LoginCoordinating {

    weak var parentCoordinator: AppCoordinating?

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    @Injected private var store: AppStore
    @Injected private var viewControllerFactory: ViewControllerFactory

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(animated: Bool) {
        let viewController = viewControllerFactory.loginVC()
        viewController.coordinator = self
        if animated {
            UIView.transition(
                with: navigationController.view,
                duration: Constants.transitionDuration,
                options: .transitionFlipFromRight,
                animations: {
                    self.navigationController.pushViewController(viewController, animated: animated)
                }
            )
        } else {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }

    func logIn() {
        parentCoordinator?.loginDidFinish()
    }
}

private enum Constants {
    static let transitionDuration: TimeInterval = 0.5
}
