//
//  Injected.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    var wrappedValue: T {
        DependencyContainer.resolve()
    }
}
