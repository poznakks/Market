//
//  TitleLabel.swift
//  Market
//
//  Created by Vlad Boguzh on 06.03.2024.
//

import UIKit

final class TitleLabel: UILabel {

    private let firstWord: String
    private let secondWord: String

    init(firstWord: String, secondWord: String) {
        self.firstWord = firstWord
        self.secondWord = secondWord
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let fullText = "\(firstWord)\n\(secondWord)"
        let attributedText = NSMutableAttributedString(string: fullText)

        if let firstRange = fullText.range(of: firstWord) {
            attributedText.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: Asset.Colors.customRed.color,
                range: NSRange(firstRange, in: fullText)
            )
        }

        if let secondRange = fullText.range(of: secondWord) {
            attributedText.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.black,
                range: NSRange(secondRange, in: fullText)
            )
        }

        attributedText.addAttribute(
            NSAttributedString.Key.font,
            value: Constants.font,
            range: NSRange(location: 0, length: fullText.count)
        )

        self.attributedText = attributedText
        numberOfLines = 2
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
    }
}

private enum Constants {
    static let font = UIFont.systemFont(ofSize: 46, weight: .bold, design: .rounded)
}
