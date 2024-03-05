//
//  DefaultCoordinatorFactory.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

final class DefaultCoordinatorFactory: CoordinatorFactory {
    func appCoordinator(_ navigationController: UINavigationController) -> AppCoordinating {
        AppCoordinator(navigationController)
    }

    func loginCoordinator(_ navigationController: UINavigationController) -> LoginCoordinating {
        LoginCoordinator(navigationController)
    }

    func mainTabBarCoordinator(_ navigationController: UINavigationController) -> MainTabBarCoordinating {
        MainTabBarCoordinator(navigationController)
    }

    func homeCoordinator(_ navigationController: UINavigationController) -> HomeCoordinating {
        HomeCoordinator(navigationController)
    }

    func searchCoordinator(_ navigationController: UINavigationController) -> SearchCoordinating {
        SearchCoordinator(navigationController)
    }

    func wishlistCoordinator(_ navigationController: UINavigationController) -> WishlistCoordinating {
        WishlistCoordinator(navigationController)
    }

    func cartCoordinator(_ navigationController: UINavigationController) -> CartCoordinating {
        CartCoordinator(navigationController)
    }

    func profileCoordinator(_ navigationController: UINavigationController) -> ProfileCoordinating {
        ProfileCoordinator(navigationController)
    }
}
