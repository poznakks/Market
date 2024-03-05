//
//  ProfileViewController.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {

    weak var coordinator: ProfileCoordinating?

    @Injected private var store: AppStore

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}
