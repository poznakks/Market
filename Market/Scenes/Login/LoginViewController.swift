//
//  LoginViewController.swift
//  Market
//
//  Created by Vlad Boguzh on 05.03.2024.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {

    // MARK: Properties
    weak var coordinator: LoginCoordinating?

    @Injected private var store: AppStore
    private var cancellables: Set<AnyCancellable> = []

    // MARK: UI Elements
    private lazy var titleLabel: TitleLabel = {
        let fullText = Constants.Strings.titleLabelText.components(separatedBy: " ")
        let label = TitleLabel(firstWord: fullText[0], secondWord: fullText[1])
        view.addSubview(label)
        return label
    }()

    private lazy var emailTextField: CredentialsTextField = {
        let textField = CredentialsTextField(
            type: .email,
            cornerRadius: Constants.Interface.textFieldAndSignInButtonCornerRadius
        )
        return textField
    }()

    private lazy var passwordTextField: CredentialsTextField = {
        let textField = CredentialsTextField(
            type: .password,
            cornerRadius: Constants.Interface.textFieldAndSignInButtonCornerRadius
        )
        return textField
    }()

    private lazy var checkbox: CheckboxWithTitle = {
        let checkbox = CheckboxWithTitle()
        return checkbox
    }()

    private lazy var forgotPasswordButton: ForgotPasswordButton = {
        let button = ForgotPasswordButton()
        button.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        return button
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

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
        subscribeOnStore()
    }

    // MARK: Private methods
    private func subscribeOnStore() {
        store
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updateState(with: $0.userState) }
            .store(in: &cancellables)
    }

    private func updateState(with state: UserState) {
        if state.user != nil {
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

    // MARK: Constraints
    // swiftlint:disable:next function_body_length
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

        let emailAndPasswordStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
            stackView.axis = .vertical
            stackView.spacing = Constants.Constraints.textFieldsSpacing
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
            return stackView
        }()

        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldAndSignInButtonHeight
            ),
            passwordTextField.heightAnchor.constraint(
                equalToConstant: Constants.Constraints.textFieldAndSignInButtonHeight
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

        let checkboxAndForgotPasswordStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [checkbox, forgotPasswordButton])
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
            return stackView
        }()

        NSLayoutConstraint.activate([
            checkboxAndForgotPasswordStackView.topAnchor.constraint(
                equalTo: emailAndPasswordStackView.bottomAnchor,
                constant: Constants.Constraints.checkboxToTextFieldsOffset
            ),
            checkboxAndForgotPasswordStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.Constraints.checkboxLeadingTrailingInset
            ),
            checkboxAndForgotPasswordStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.Constraints.checkboxLeadingTrailingInset
            ),
            checkboxAndForgotPasswordStackView.heightAnchor.constraint(
                equalToConstant: Constants.Constraints.checkboxHeight
            )
        ])

        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(
                equalTo: checkbox.bottomAnchor,
                constant: Constants.Constraints.signInButtonToCheckboxOffset
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

    // MARK: Actions
    @objc
    private func didTapLoginButton() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let rememberUser = checkbox.isChecked
        store.dispatch(
            .user(.auth(.login(email: email, password: password, rememberUser: rememberUser)))
        )
    }

    @objc
    private func didTapForgotPassword() {
        print(#function)
    }
}

// MARK: - Constants
private enum Constants {
    enum Interface {
        static let textFieldAndSignInButtonCornerRadius: CGFloat = 20
    }

    enum Constraints {
        static let leadingTrailingInset: CGFloat = 20
        static let titleToTopOffset: CGFloat = 30
        static let textFieldsToTitleOffset: CGFloat = 100
        static let textFieldsSpacing: CGFloat = 15
        static let checkboxToTextFieldsOffset: CGFloat = 30
        static let checkboxLeadingTrailingInset: CGFloat = leadingTrailingInset + 10
        static let checkboxHeight: CGFloat = 10
        static let signInButtonToCheckboxOffset: CGFloat = 30
        static let textFieldAndSignInButtonHeight: CGFloat = 50
    }

    enum Strings {
        static let titleLabelText = String(localized: LocalizableStrings.titleLabelText)
    }

    private enum LocalizableStrings {
        static let titleLabelText: LocalizedStringResource = "Welcome back!"
    }
}
