//
//  AppReducer.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .user(action: let action):
        userReducer(state: &state.userState, action: action)
    }
}
