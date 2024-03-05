//
//  TabBarPage.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

enum TabBarPage: CaseIterable {
    case home
    case search
    case wishlist
    case cart
    case profile

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .wishlist:
            return "Wishlist"
        case .cart:
            return "Cart"
        case .profile:
            return "Profile"
        }
    }

    // swiftlint:disable force_unwrapping
    var image: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house")!

        case .search:
            return UIImage(systemName: "magnifyingglass")!

        case .wishlist:
            return UIImage(systemName: "heart")!

        case .cart:
            return UIImage(systemName: "cart")!

        case .profile:
            return UIImage(systemName: "person")!
        }
    }
    // swiftlint:enable force_unwrapping

    var tag: Int {
        switch self {
        case .home:
            return 0

        case .search:
            return 1

        case .wishlist:
            return 2

        case .cart:
            return 3

        case .profile:
            return 4
        }
    }
}
