//
//  DependencyContainer.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

final class DependencyContainer {

    private var dependencies: [String: AnyObject] = [:]
    private static let shared = DependencyContainer()

    private init() {}

    static func register<T>(_ dependency: T, for type: T.Type) {
        shared.register(dependency, for: type)
    }

    static func resolve<T>() -> T {
        shared.resolve()
    }

    private func register<T>(_ dependency: T, for type: T.Type) {
        let key = String(describing: T.self)
        dependencies[key] = dependency as AnyObject
    }

    private func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("Cannot resolve a dependency for \(T.self)")
        }
        return dependency
    }
}

extension DependencyContainer {
    @MainActor
    static func registerAllDependencies() {
        register(DefaultUserService(), for: UserService.self)

        register(
            AppStore(
                state: AppState(),
                reducer: appReducer,
                middlewares: [userMiddleware(service: resolve())]
            ),
            for: AppStore.self
        )

        register(DefaultCoordinatorFactory(), for: CoordinatorFactory.self)
        register(DefaultViewControllerFactory(), for: ViewControllerFactory.self)
    }
}
