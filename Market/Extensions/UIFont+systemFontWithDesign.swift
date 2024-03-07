//
//  UIFont+systemFontWithDesign.swift
//  Market
//
//  Created by Vlad Boguzh on 06.03.2024.
//

import UIKit

extension UIFont {
    static func systemFont(
        ofSize size: CGFloat,
        weight: UIFont.Weight,
        design: UIFontDescriptor.SystemDesign
    ) -> UIFont {
        let systemFont = systemFont(ofSize: size, weight: weight)
        guard let descriptor = systemFont.fontDescriptor.withDesign(design) else {
            return systemFont
        }
        return UIFont(descriptor: descriptor, size: size)
    }
}
