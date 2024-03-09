//
//  CredentialsTextField.swift
//  Market
//
//  Created by Vlad Boguzh on 06.03.2024.
//

import UIKit

enum TextFieldType {
    case email
    case password
}

final class CredentialsTextField: UITextField {

    // MARK: Properties
    private let type: TextFieldType
    private let cornerRadius: CGFloat

    // MARK: Lifecycle
    init(type: TextFieldType, cornerRadius: CGFloat) {
        self.type = type
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)

        delegate = self
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup text field
    private func setup() {
        borderStyle = .roundedRect
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        autocapitalizationType = .none
        autocorrectionType = .no
        textColor = .black
        font = Constants.Interface.font
        layer.borderColor = Asset.Colors.textFieldBorder.color.cgColor
        layer.borderWidth = Constants.Interface.borderWidth
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false

        switch type {
        case .email:
            setupEmail()

        case .password:
            setupPassword()
        }

        updateAppearance()
    }

    private func setupEmail() {
        placeholder = Constants.Strings.emailPlaceholder
        keyboardType = .emailAddress
    }

    private func setupPassword() {
        placeholder = Constants.Strings.passwordPlaceholder
        isSecureTextEntry = true
    }

    // MARK: Left and right view
    private func setupLeftRightView(position: ViewPosition, symbol: UIImage) {
        let view = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: Constants.Interface.leftRightViewWidth,
                height: frame.height)
        )
        let symbolImageView = UIImageView(
            frame: CGRect(
                x: position == .left ? Constants.Interface.leftRightViewPadding : 0,
                y: 0,
                width: Constants.Interface.leftRightViewSymbolImageViewWidth,
                height: frame.height
            )
        )
        if position == .left {
            symbolImageView.transform = CGAffineTransform(
                scaleX: Constants.Interface.leftSymbolScale,
                y: Constants.Interface.leftSymbolScale
            )
        }
        if position == .right {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(didTapTogglePasswordVisibility)
            )
            view.addGestureRecognizer(tapGesture)
        }

        symbolImageView.image = symbol
        symbolImageView.contentMode = .center
        view.addSubview(symbolImageView)

        switch position {
        case .left:
            leftView = view
            leftViewMode = .always

        case .right:
            rightView = view
            rightViewMode = .always
        }
    }
    
    // MARK: Actions
    @objc
    private func didTapTogglePasswordVisibility() {
        isSecureTextEntry.toggle()
        updateAppearance()
    }

    private func updateAppearance() {
        if isEditing {
            layer.borderColor = UIColor.black.cgColor

            switch type {
            case .email:
                setupLeftRightView(position: .left, symbol: Constants.Symbols.envelopeBlack)

            case .password:
                setupLeftRightView(position: .left, symbol: Constants.Symbols.lockBlack)
                setupLeftRightView(
                    position: .right,
                    symbol: isSecureTextEntry ? Constants.Symbols.eyeSlashBlack : Constants.Symbols.eyeBlack
                )
            }
        } else {
            guard (text ?? "").isEmpty else {
                return
            }
            layer.borderColor = Asset.Colors.textFieldBorder.color.cgColor

            switch type {
            case .email:
                setupLeftRightView(position: .left, symbol: Constants.Symbols.envelopeLightGray)

            case .password:
                setupLeftRightView(position: .left, symbol: Constants.Symbols.lockLightGray)
                setupLeftRightView(
                    position: .right,
                    symbol: isSecureTextEntry ? Constants.Symbols.eyeSlashLightGray : Constants.Symbols.eyeLightGray
                )
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension CredentialsTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateAppearance()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAppearance()
    }
}

// MARK: - Constants
private enum Constants {

    // swiftlint:disable force_unwrapping
    enum Symbols {
        static let envelopeLightGray = UIImage.systemImageWithColor(name: "envelope", color: .lightGray)!
        static let envelopeBlack = UIImage.systemImageWithColor(name: "envelope", color: .black)!

        static let lockLightGray = UIImage.systemImageWithColor(name: "lock", color: .lightGray)!
        static let lockBlack = UIImage.systemImageWithColor(name: "lock", color: .black)!

        static let eyeSlashLightGray = UIImage.systemImageWithColor(name: "eye.slash", color: .lightGray)!
        static let eyeSlashBlack = UIImage.systemImageWithColor(name: "eye.slash", color: .black)!

        static let eyeLightGray = UIImage.systemImageWithColor(name: "eye", color: .lightGray)!
        static let eyeBlack = UIImage.systemImageWithColor(name: "eye", color: .black)!
    }
    // swiftlint:enable force_unwrapping

    enum Interface {
        static let borderWidth: CGFloat = 1
        static let leftRightViewPadding: CGFloat = 15
        static let leftRightViewSymbolImageViewWidth: CGFloat = 30
        static let leftRightViewWidth: CGFloat =
        leftRightViewPadding + leftRightViewSymbolImageViewWidth
        static let leftSymbolScale: CGFloat = 1.25

        static let font = UIFont.systemFont(ofSize: 18, weight: .medium, design: .rounded)
    }

    enum Strings {
        static let emailPlaceholder = String(localized: LocalizableStrings.emailPlaceholder)
        static let passwordPlaceholder = String(localized: LocalizableStrings.passwordPlaceholder)
    }

    private enum LocalizableStrings {
        static let emailPlaceholder: LocalizedStringResource = "Enter you email"
        static let passwordPlaceholder: LocalizedStringResource = "Enter you password"
    }
}

private enum ViewPosition {
    case left
    case right
}
