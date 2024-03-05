//
//  CoordinatorFactory.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

@MainActor
protocol CoordinatorFactory {
    func appCoordinator(_ navigationController: UINavigationController) -> AppCoordinating

    func loginCoordinator(_ navigationController: UINavigationController) -> LoginCoordinating
    func mainTabBarCoordinator(_ navigationController: UINavigationController) -> MainTabBarCoordinating

    func homeCoordinator(_ navigationController: UINavigationController) -> HomeCoordinating
    func searchCoordinator(_ navigationController: UINavigationController) -> SearchCoordinating
    func wishlistCoordinator(_ navigationController: UINavigationController) -> WishlistCoordinating
    func cartCoordinator(_ navigationController: UINavigationController) -> CartCoordinating
    func profileCoordinator(_ navigationController: UINavigationController) -> ProfileCoordinating
}
