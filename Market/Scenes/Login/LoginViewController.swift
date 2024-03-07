//
//  LoginViewController.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {

    weak var coordinator: LoginCoordinating?

    @Injected private var store: AppStore
    private var cancellables: Set<AnyCancellable> = []

    private lazy var titleLabel: TitleLabel = {
        let fullText = Constants.Strings.titleLabelText.components(separatedBy: " ")
        let label = TitleLabel(firstWord: fullText[0], secondWord: fullText[1])
        view.addSubview(label)
        return label
    }()

    private lazy var emailAndPasswordStackView: EmailAndPasswordStackView = {
        let stackView = EmailAndPasswordStackView(
            cornerRadius: Constants.Interface.textFieldAndSignInButtonCornerRadius,
            height: Constants.Constraints.textFieldAndSignInButtonHeight
        )
        view.addSubview(stackView)
        return stackView
    }()

    private lazy var signInButton: SignInButton = {
        let button = SignInButton(
            cornerRadius: Constants.Interface.textFieldAndSignInButtonCornerRadius
        )
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()

    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
        subscribeOnStore()
    }

    private func subscribeOnStore() {
        store
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updateState(with: $0.userState) }
            .store(in: &cancellables)
    }

    private func updateState(with state: UserState) {
        if let user = state.user {
            coordinator?.logIn()
            return
        }

        switch state.authState.loginError {
        case .notEmail:
            stateLabel.text = "notEmail"
            return

        case .shortPassword:
            stateLabel.text = "shortPassword"
            return

        case .wrongCredentials:
            stateLabel.text = "wrongCredentials"
            return

        case .none:
            break
        }

        if state.authState.isLoggingIn {
            stateLabel.text = "Logging in"
            return
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.Constraints.titleToTopOffset
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.Constraints.leadingTrailingInset
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.Constraints.leadingTrailingInset
            )
        ])

        NSLayoutConstraint.activate([
            emailAndPasswordStackView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.Constraints.textFieldsToTitleOffset
            ),
            emailAndPasswordStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.Constraints.leadingTrailingInset
            ),
            emailAndPasswordStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.Constraints.leadingTrailingInset
            )
        ])

        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(
                equalTo: emailAndPasswordStackView.bottomAnchor,
                constant: Constants.Constraints.signInButtonToTextFieldsOffset
            ),
            signInButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.Constraints.leadingTrailingInset
            ),
            signInButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.Constraints.leadingTrailingInset
            ),
            signInButton.heightAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldAndSignInButtonHeight
            )
        ])
    }

    @objc
    private func didTapLoginButton() {
        let email = emailAndPasswordStackView.emailText
        let password = emailAndPasswordStackView.passwordText
        store.dispatch(.user(.auth(.login(email: email, password: password))))
    }
}

private enum Constants {
    enum Interface {
        static let textFieldAndSignInButtonCornerRadius: CGFloat = 20
    }

    enum Constraints {
        static let leadingTrailingInset: CGFloat = 20
        static let titleToTopOffset: CGFloat = 30
        static let textFieldsToTitleOffset: CGFloat = 100
        static let signInButtonToTextFieldsOffset: CGFloat = 30
        static let textFieldAndSignInButtonHeight: CGFloat = 50
    }

    enum Strings {
        static let titleLabelText = String(localized: LocalizableStrings.titleLabelText)
    }

    private enum LocalizableStrings {
        static let titleLabelText: LocalizedStringResource = "Welcome back!"
    }
}
