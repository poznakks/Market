//
//  ViewControllerFactory.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

@MainActor
protocol ViewControllerFactory {
    func loginVC() -> LoginViewController

    func homeVC() -> HomeViewController
    func searchVC() -> SearchViewController
    func wishlistVC() -> WishlistViewController
    func cartVC() -> CartViewController
    func profileVC() -> ProfileViewController
}
