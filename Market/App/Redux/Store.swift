//
//  Store.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import Foundation
import Combine

typealias AppStore = Store<AppState, AppAction>

typealias Reducer<State, Action> = (inout State, Action) -> Void
typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

final class Store<State, Action>: Publisher {
    typealias Output = State
    typealias Failure = Never

    var state: State {
        subject.value
    }

    private let subject: CurrentValueSubject<State, Never>
    private let reducer: Reducer<State, Action>
    private var middlewares: [Middleware<State, Action>]

    private var cancellables: Set<AnyCancellable> = []

    init(
        state: State,
        reducer: @escaping Reducer<State, Action>,
        middlewares: [Middleware<State, Action>]
    ) {
        self.subject = CurrentValueSubject(state)
        self.reducer = reducer
        self.middlewares = middlewares
    }

    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, State == S.Input {
        subject.receive(subscriber: subscriber)
    }

    func addMiddleware(_ middleware: @escaping Middleware<State, Action>) {
        middlewares.append(middleware)
    }

    func dispatch(_ action: Action) {
        reducer(&subject.value, action)

        for middleware in middlewares {
            middleware(subject.value, action)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in self?.dispatch($0) }
                .store(in: &cancellables)
        }

        subject.send(subject.value)
    }
}
