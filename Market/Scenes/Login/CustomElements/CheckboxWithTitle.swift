//
//  CheckboxWithTitle.swift
//  Market
//
//  Created by Vlad Boguzh on 07.03.2024.
//

import UIKit

final class CheckboxWithTitle: UIView {

    // MARK: Properties
    private(set) var isChecked = false {
        didSet {
            if isChecked {
                checkbox.image = Constants.Symbols.checkmarkChecked
            } else {
                checkbox.image = Constants.Symbols.checkmarkUnchecked
            }
        }
    }

    // MARK: UI Elements
    private lazy var checkbox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Symbols.checkmarkUnchecked
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Interface.font
        label.text = Constants.Strings.rememberMeLabel
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true

        checkbox.transform = CGAffineTransform(
            scaleX: Constants.Interface.checkboxScale,
            y: Constants.Interface.checkboxScale
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
        addGestureRecognizer(tapGesture)
    }

    // MARK: Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkbox.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: checkbox.trailingAnchor,
                constant: Constants.Constraints.titleToCheckboxSpacing
            ),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: Actions
    @objc
    private func didTapCheckbox() {
        isChecked.toggle()
    }
}

// MARK: - Constants
private enum Constants {
    // swiftlint:disable force_unwrapping
    enum Symbols {
        static let checkmarkChecked = UIImage.systemImageWithColor(
            name: "checkmark.square.fill",
            color: Asset.Colors.customRed.color
        )!
        static let checkmarkUnchecked = UIImage.systemImageWithColor(name: "square", color: .lightGray)!
    }
    // swiftlint:enable force_unwrapping

    enum Interface {
        static let font = UIFont.systemFont(ofSize: 15, weight: .semibold, design: .rounded)
        static let checkboxScale: CGFloat = 1.25
    }

    enum Constraints {
        static let titleToCheckboxSpacing: CGFloat = 4
    }

    enum Strings {
        static let rememberMeLabel = String(localized: LocalizableStrings.rememberMeLabel)
    }

    private enum LocalizableStrings {
        static let rememberMeLabel: LocalizedStringResource = "Remember Me"
    }
}
