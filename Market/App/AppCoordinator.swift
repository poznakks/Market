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
        let shouldRememberUser = UserDefaults.standard.shouldRememberUser
        let savedUser = UserDefaults.standard.savedUser
        if let savedUser, shouldRememberUser {
            store.dispatch(.user(.auth(.loginSuccess(user: savedUser))))
            startMainFlow(animated: animated)
        } else {
            startLoginFlow(animated: animated)
        }
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
}

extension UserDefaults {
    private static let shouldRememberUserKey = "shouldRememberUser"

    var shouldRememberUser: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaults.shouldRememberUserKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.shouldRememberUserKey)
        }
    }

    private static let savedUserKey = "savedUserKey"

    var savedUser: User? {
        get {
            if let storedData = UserDefaults.standard.data(forKey: UserDefaults.savedUserKey),
               let decodedUser = try? JSONDecoder().decode(User.self, from: storedData) {
                return decodedUser
            } else {
                return nil
            }
        }
        set {
            if let encodedUser = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedUser, forKey: UserDefaults.savedUserKey)
            }
        }
    }
}
