//
//  UserMiddleware.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation
import Combine

func userMiddleware(service: UserService) -> Middleware<AppState, AppAction> {
    { _, action in
        switch action {
        case .user(.auth(let .login(email, password))):
            return service.login(email: email, password: password)
                .subscribe(on: DispatchQueue.main)
                .map { AppAction.user(.auth(.loginSuccess(user: $0))) }
                .catch { Just(AppAction.user(.auth(.loginError(error: $0)))) }
                .eraseToAnyPublisher()

        case .user(.updateEmail(let .changeEmail(email, user))):
            return service.changeEmail(to: email, for: user)
                .subscribe(on: DispatchQueue.main)
                .map { AppAction.user(.updateEmail(.emailChangeSuccess(user: $0))) }
                .catch { Just(AppAction.user(.updateEmail(.emailChangeError(error: $0)))) }
                .eraseToAnyPublisher()

        case .user(.updatePassword(let .changePassword(password, user))):
            return service.changePassword(to: password, for: user)
                .subscribe(on: DispatchQueue.main)
                .map { AppAction.user(.updatePassword(.passwordChangeSuccess(user: $0))) }
                .catch { Just(AppAction.user(.updatePassword(.passwordChangeError(error: $0)))) }
                .eraseToAnyPublisher()

        default:
            return Empty().eraseToAnyPublisher()
        }
    }
}
