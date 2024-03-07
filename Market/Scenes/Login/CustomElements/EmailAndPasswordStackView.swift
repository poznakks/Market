//
//  EmailAndPasswordStackView.swift
//  Market
//
//  Created by Vlad Boguzh on 06.03.2024.
//

import UIKit

final class EmailAndPasswordStackView: UIStackView {

    var emailText: String {
        emailTextField.text ?? ""
    }

    var passwordText: String {
        passwordTextField.text ?? ""
    }

    private let cornerRadius: CGFloat
    private let height: CGFloat

    private lazy var emailTextField: CredentialsTextField = {
        let textField = CredentialsTextField(
            type: .email,
            cornerRadius: cornerRadius
        )
        return textField
    }()

    private lazy var passwordTextField: CredentialsTextField = {
        let textField = CredentialsTextField(
            type: .password,
            cornerRadius: cornerRadius
        )
        return textField
    }()

    init(cornerRadius: CGFloat, height: CGFloat) {
        self.cornerRadius = cornerRadius
        self.height = height
        super.init(frame: .zero)
        setup()
        setupConstraints()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addArrangedSubview(emailTextField)
        addArrangedSubview(passwordTextField)
        axis = .vertical
        spacing = Constants.spacing
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: height),
            passwordTextField.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

private enum Constants {
    static let spacing: CGFloat = 15
}

