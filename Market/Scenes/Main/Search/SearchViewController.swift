//
//  SearchViewController.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

final class SearchViewController: UIViewController {

    weak var coordinator: SearchCoordinating?

    @Injected private var store: AppStore

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
