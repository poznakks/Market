//
//  UserService.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation
import Combine

protocol UserService {
    func login(email: String, password: String) -> AnyPublisher<User, UserLoginError>
    func changeEmail(to newEmail: String, for user: User) -> AnyPublisher<User, UserEmailChangeError>
    func changePassword(to newPassword: String, for user: User) -> AnyPublisher<User, UserPasswordChangeError>
}
