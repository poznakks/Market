//
//  Coordinator.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    func start(animated: Bool)
}
