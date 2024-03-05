//
//  DefaultViewControllerFactory.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

final class DefaultViewControllerFactory: ViewControllerFactory {
    func loginVC() -> LoginViewController {
        LoginViewController()
    }

    func homeVC() -> HomeViewController {
        HomeViewController()
    }

    func searchVC() -> SearchViewController {
        SearchViewController()
    }

    func wishlistVC() -> WishlistViewController {
        WishlistViewController()
    }

    func cartVC() -> CartViewController {
        CartViewController()
    }

    func profileVC() -> ProfileViewController {
        ProfileViewController()
    }
}
