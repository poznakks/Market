//
//  ForgotPasswordButton.swift
//  Market
//
//  Created by Vlad Boguzh on 08.03.2024.
//

import UIKit

final class ForgotPasswordButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setTitle("Forgot password?", for: .normal)
        setTitleColor(Asset.Colors.customBlue.color, for: .normal)
        titleLabel?.font = Constants.Interface.font
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
}

private enum Constants {
    enum Interface {
        static let font = UIFont.systemFont(ofSize: 15, weight: .semibold, design: .rounded)
    }

    enum Strings {
        static let buttonLabel = String(localized: LocalizableStrings.buttonLabel)
    }

    private enum LocalizableStrings {
        static let buttonLabel: LocalizedStringResource = "Forgot password?"
    }
}
