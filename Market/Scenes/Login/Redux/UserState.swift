//
//  UserState.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

struct UserState {
    var user: User?
    var authState = UserAuthState()
    var emailState = UserEmailState()
    var passwordState = UserPasswordState()
}

struct UserAuthState {
    var isLoggingIn = false
    var loginError: UserLoginError?
}

struct UserEmailState {
    var isChangingEmail = false
    var emailChangeError: UserEmailChangeError?
}

struct UserPasswordState {
    var isChangingPassword = false
    var passwordChangeError: UserPasswordChangeError?
}
