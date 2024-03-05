//
//  CredentialsValidating.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

protocol CredentialsValidating {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
}
