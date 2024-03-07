//
//  UIImage+systemImageWithColor.swift
//  Market
//
//  Created by Vlad Boguzh on 06.03.2024.
//

import UIKit

extension UIImage {
    static func systemImageWithColor(name: String, color: UIColor) -> UIImage? {
        let image = UIImage(systemName: name)
        return image?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
