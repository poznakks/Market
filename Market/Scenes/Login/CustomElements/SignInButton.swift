//
//  SignInButton.swift
//  Market
//
//  Created by Vlad Boguzh on 06.03.2024.
//

import UIKit

final class SignInButton: UIButton {

    private let cornerRadius: CGFloat

    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setTitle(Constants.Strings.loginButtonLabel, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Constants.Interface.font
        backgroundColor = Asset.Colors.customRed.color
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
}

private enum Constants {
    enum Interface {
        static let font = UIFont.systemFont(ofSize: 18, weight: .semibold, design: .rounded)
    }

    enum Strings {
        static let loginButtonLabel = String(localized: LocalizableStrings.loginButtonLabel)
    }

    private enum LocalizableStrings {
        static let loginButtonLabel: LocalizedStringResource = "Sign In"
    }
}
