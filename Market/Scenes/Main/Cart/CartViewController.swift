//
//  CartViewController.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

final class CartViewController: UIViewController {

    weak var coordinator: CartCoordinating?

    @Injected private var store: AppStore

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
}
