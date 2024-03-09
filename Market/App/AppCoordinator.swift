//
//  AppCoordinator.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit

@MainActor
protocol AppCoordinating: Coordinator {
    func loginDidFinish()
    func logOutDidFinish()
}

final class AppCoordinator: AppCoordinating {

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    @Injected private var store: AppStore
    @Injected private var coordinatorFactory: CoordinatorFactory

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(animated: Bool) {
        let rememberUser = UserDefaults.standard.rememberUser
        if rememberUser {
            startMainFlow(animated: animated)
        } else {
            startLoginFlow(animated: animated)
        }
    }

    private func startLoginFlow(animated: Bool) {
        let child = coordinatorFactory.loginCoordinator(navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(animated: animated)
    }

    private func startMainFlow(animated: Bool) {
        let child = coordinatorFactory.mainTabBarCoordinator(navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(animated: animated)
    }

    func loginDidFinish() {
        for (index, coordinator) in childCoordinators.enumerated()
        where coordinator is LoginCoordinating {
            childCoordinators.remove(at: index)
        }
        navigationController.viewControllers.removeAll()
        startMainFlow(animated: true)
    }

    func logOutDidFinish() {
        for (index, coordinator) in childCoordinators.enumerated()
        where coordinator is MainTabBarCoordinating {
            childCoordinators.remove(at: index)
        }
        navigationController.viewControllers.removeAll()
        startLoginFlow(animated: true)
    }
}

extension UserDefaults {
    private static let rememberUserKey = "rememberUser"

    var rememberUser: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaults.rememberUserKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.rememberUserKey)
        }
    }

    private static let rememberedUserEmailKey = "rememberedUserEmail"

    var rememberedUserEmail: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaults.rememberedUserEmailKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.rememberUserKey)
        }
    }
}
