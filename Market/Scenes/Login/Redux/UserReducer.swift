//
//  UserReducer.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

func userReducer(state: inout UserState, action: UserAction) {
    let userStateUpdater: (User?) -> Void = { user in
        state.user = user
    }
    switch action {
    case .auth(action: let action):
        userAuthReducer(state: &state.authState, action: action, userStateUpdater: userStateUpdater)

    case .updateEmail(action: let action):
        userEmailReducer(state: &state.emailState, action: action, userStateUpdater: userStateUpdater)

    case .updatePassword(action: let action):
        userPasswordReducer(state: &state.passwordState, action: action, userStateUpdater: userStateUpdater)
    }
}

func userAuthReducer(
    state: inout UserAuthState,
    action: UserAuthAction,
    userStateUpdater: (User?) -> Void
) {
    switch action {
    case .login:
        state.isLoggingIn = true
        state.loginError = nil

    case .loginSuccess(user: let user):
        state.isLoggingIn = false
        state.loginError = nil
        userStateUpdater(user)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(user.email, forKey: "currentUser")

    case .loginError(error: let error):
        state.isLoggingIn = false
        state.loginError = error

    case .logOut:
        state.isLoggingIn = false
        state.loginError = nil
        userStateUpdater(nil)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(nil, forKey: "currentUser")
    }
}

func userEmailReducer(
    state: inout UserEmailState,
    action: UserEmailAction,
    userStateUpdater: (User?) -> Void
) {
    switch action {
    case .changeEmail:
        state.isChangingEmail = true
        state.emailChangeError = nil

    case .emailChangeSuccess(user: let user):
        state.isChangingEmail = false
        state.emailChangeError = nil
        userStateUpdater(user)

    case .emailChangeError(error: let error):
        state.isChangingEmail = false
        state.emailChangeError = error
    }
}

func userPasswordReducer(
    state: inout UserPasswordState,
    action: UserPasswordAction,
    userStateUpdater: (User?) -> Void
) {
    switch action {
    case .changePassword:
        state.isChangingPassword = true
        state.passwordChangeError = nil

    case .passwordChangeSuccess(user: let user):
        state.isChangingPassword = false
        state.passwordChangeError = nil
        userStateUpdater(user)

    case .passwordChangeError(error: let error):
        state.isChangingPassword = false
        state.passwordChangeError = error
    }
}
