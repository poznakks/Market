//
//  ProfileCoordinator.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

@MainActor
protocol ProfileCoordinating: MainTabBarChildCoordinating {
//    func logOut()
}

final class ProfileCoordinator: ProfileCoordinating {

    weak var parentCoordinator: MainTabBarCoordinating?

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    @Injected private var store: AppStore
    @Injected private var viewControllerFactory: ViewControllerFactory

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(animated: Bool) {
        let viewController = viewControllerFactory.profileVC()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: animated)
    }

//    func logOut() {
//        parentCoordinator?.logOut()
//    }
}
