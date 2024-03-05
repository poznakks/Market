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

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.Strings.emailPlaceholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = Constants.TextField.textFieldCornerRadius
        textField.layer.masksToBounds = true
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textColor = .darkText
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = Constants.TextField.textFieldBorderWidth
        textField.backgroundColor = UIColor(white: 0.965, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.Strings.passwordPlaceholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = Constants.TextField.textFieldCornerRadius
        textField.layer.masksToBounds = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.textColor = .darkText
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = Constants.TextField.textFieldBorderWidth
        textField.backgroundColor = UIColor(white: 0.965, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Strings.loginButtonLabel, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.TextField.textFieldCornerRadius
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
            stateLabel.text = "\(user)"
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
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constants.Constraints.emailTextFieldToTop
            ),
            emailTextField.widthAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldsAndLoginButtonWidth
            ),
            emailTextField.heightAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldsAndLoginButtonHeight
            )
        ])

        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(
                equalTo: emailTextField.bottomAnchor,
                constant: Constants.Constraints.passwordTextFieldToEmailTextField
            ),
            passwordTextField.widthAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldsAndLoginButtonWidth
            ),
            passwordTextField.heightAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldsAndLoginButtonHeight
            )
        ])

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor,
                constant: Constants.Constraints.loginButtonToPasswordTextField
            ),
            loginButton.widthAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldsAndLoginButtonWidth
            ),
            loginButton.heightAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldsAndLoginButtonHeight
            )
        ])

        NSLayoutConstraint.activate([
            stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateLabel.topAnchor.constraint(
                equalTo: loginButton.bottomAnchor,
                constant: Constants.Constraints.loginButtonToPasswordTextField
            )
        ])
    }

    @objc
    private func didTapLoginButton() {
        let email = emailTextField.text ?? .empty
        let password = passwordTextField.text ?? .empty
        store.dispatch(.user(.auth(.login(email: email, password: password))))
    }
}

private enum Constants {
    enum TextField {
        static let textFieldCornerRadius: CGFloat = 12
        static let textFieldBorderWidth: CGFloat = 1
    }

    enum Constraints {
        static let emailTextFieldToTop: CGFloat = 300
        static let passwordTextFieldToEmailTextField: CGFloat = 20
        static let loginButtonToPasswordTextField: CGFloat = 30
        static let textFieldsAndLoginButtonWidth: CGFloat = 350
        static let textFieldsAndLoginButtonHeight: CGFloat = 50
    }

    enum Strings {
        static let emailPlaceholder: String = "test@example.com"
        static let passwordPlaceholder: String = "password"
        static let loginButtonLabel = String(localized: LocalizableStrings.loginButtonLabel)
    }

    private enum LocalizableStrings {
        static let loginButtonLabel: LocalizedStringResource = "Login"
    }
}

extension String {
    static var empty: Self {
        ""
    }
}
