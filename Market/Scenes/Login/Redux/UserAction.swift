//
//  UserAction.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

enum UserAction {
    case auth(UserAuthAction)
    case updateEmail(UserEmailAction)
    case updatePassword(UserPasswordAction)
}

enum UserAuthAction {
    case login(email: String, password: String, shouldRememberUser: Bool)
    case loginSuccess(user: User)
    case loginError(error: UserLoginError?)
    case logOut
}

enum UserEmailAction {
    case changeEmail(email: String, user: User)
    case emailChangeSuccess(user: User)
    case emailChangeError(error: UserEmailChangeError)
}

enum UserPasswordAction {
    case changePassword(password: String, user: User)
    case passwordChangeSuccess(user: User)
    case passwordChangeError(error: UserPasswordChangeError)
}
