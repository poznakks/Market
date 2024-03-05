//
//  DefaultUserService.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation
import Combine

final class DefaultUserService: UserService {

    private var users: [String: User] = [:]

    init() {
        let email = "test@email.com"
        let password = "admin"
        let user = User(name: "Vlad", email: email, password: password)
        users[email] = user
    }

    func login(email: String, password: String) -> AnyPublisher<User, UserLoginError> {
        Future<User, UserLoginError> { [weak self] promise in
            guard let self else { return }
            guard self.isValidEmail(email) else {
                promise(.failure(.notEmail))
                return
            }
            guard self.isValidPassword(password) else {
                promise(.failure(.shortPassword))
                return
            }

            if let user = self.users[email] {
                promise(.success(user))
            } else {
                promise(.failure(.wrongCredentials))
            }
        }
        .eraseToAnyPublisher()
    }

    func changeEmail(to newEmail: String, for user: User) -> AnyPublisher<User, UserEmailChangeError> {
        Future<User, UserEmailChangeError> { [weak self] promise in
            guard let self else { return }
            guard self.isValidEmail(newEmail) else {
                promise(.failure(.notEmail))
                return
            }
            guard let user = self.users[user.email],
                  user.email != newEmail
            else {
                promise(.failure(.sameEmail))
                return
            }
            let userWithUpdatedEmail = user.changedEmailUser(to: newEmail)
            self.users[user.email] = nil
            self.users[newEmail] = userWithUpdatedEmail
            promise(.success(userWithUpdatedEmail))
        }
        .eraseToAnyPublisher()
    }

    func changePassword(to newPassword: String, for user: User) -> AnyPublisher<User, UserPasswordChangeError> {
        Future<User, UserPasswordChangeError> { [weak self] promise in
            guard let self else { return }
            guard self.isValidPassword(newPassword) else {
                promise(.failure(.shortPassword))
                return
            }
            guard let user = self.users[user.email],
                  user.password != newPassword
            else {
                promise(.failure(.samePassword))
                return
            }
            let userWithUpdatedPassword = user.changedPasswordUser(to: newPassword)
            self.users[user.email] = userWithUpdatedPassword
            promise(.success(userWithUpdatedPassword))
        }
        .eraseToAnyPublisher()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        password.count >= 4 ? true : false
    }
}
