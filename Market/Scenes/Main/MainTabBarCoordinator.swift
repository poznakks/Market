//
//  MainTabBarCoordinator.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

@MainActor
protocol MainTabBarCoordinating: Coordinator {
    var parentCoordinator: AppCoordinating? { get set }
    func logOut()
}

@MainActor
protocol MainTabBarChildCoordinating: Coordinator {
    var parentCoordinator: MainTabBarCoordinating? { get set }
}

final class MainTabBarCoordinator: MainTabBarCoordinating {

    weak var parentCoordinator: AppCoordinating?

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    @Injected private var store: AppStore
    @Injected private var coordinatorFactory: CoordinatorFactory

    private let tabBarController = UITabBarController()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(animated: Bool) {
        setupTabBar()
        if animated {
            UIView.transition(
                with: navigationController.view,
                duration: 0.5,
                options: .transitionFlipFromRight,
                animations: {
                    self.navigationController.viewControllers = [self.tabBarController]
                }
            )
        } else {
            navigationController.viewControllers = [tabBarController]
        }
    }

    func logOut() {
        parentCoordinator?.logOutDidFinish()
    }

    private func setupTabBar() {
        let controllers: [UINavigationController] = TabBarPage.allCases.map { prepareTab($0) }
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.home.tag
        tabBarController.tabBar.backgroundColor = .systemBackground
        navigationController.navigationBar.isTranslucent = false
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    private func prepareTab(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.tabBarItem = UITabBarItem(title: page.title,
                                                image: page.image,
                                                tag: page.tag)

        let child: MainTabBarChildCoordinating
        switch page {
        case .home:
            child = coordinatorFactory.homeCoordinator(navController)

        case .search:
            child = coordinatorFactory.searchCoordinator(navController)

        case .wishlist:
            child = coordinatorFactory.wishlistCoordinator(navController)

        case .cart:
            child = coordinatorFactory.cartCoordinator(navController)

        case .profile:
            child = coordinatorFactory.profileCoordinator(navController)
        }

        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(animated: true)

        return navController
    }
}
