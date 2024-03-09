//
//  User.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

struct User: Codable {
    let name: String
    let email: String
    let password: String

    func changedEmailUser(to newEmail: String) -> Self {
        User(name: name, email: newEmail, password: password)
    }

    func changedPasswordUser(to newPassword: String) -> Self {
        User(name: name, email: email, password: newPassword)
    }
}
