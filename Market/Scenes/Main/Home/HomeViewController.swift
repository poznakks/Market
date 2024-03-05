//
//  HomeViewController.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

final class HomeViewController: UIViewController {

    weak var coordinator: HomeCoordinating?

    @Injected private var store: AppStore

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
