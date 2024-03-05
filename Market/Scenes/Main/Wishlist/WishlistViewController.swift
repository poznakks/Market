//
//  WishlistViewController.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

final class WishlistViewController: UIViewController {

    weak var coordinator: WishlistCoordinating?

    @Injected private var store: AppStore

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
