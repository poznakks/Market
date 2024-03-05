//
//  UserErrors.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

enum UserLoginError: Error {
    case notEmail
    case shortPassword
    case wrongCredentials
}

enum UserEmailChangeError: Error {
    case sameEmail
    case notEmail
}

enum UserPasswordChangeError: Error {
    case samePassword
    case shortPassword
}
