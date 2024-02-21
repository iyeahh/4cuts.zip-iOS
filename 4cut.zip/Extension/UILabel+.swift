//
//  UILabel+.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import UIKit

extension UILabel {

    func asColor() {
        let fullText = text ?? ""
        let array = fullText.split(separator: " ")
        let filteredArray = array.filter { $0.contains("#") }
        let attributedString = NSMutableAttributedString(string: fullText)

        filteredArray.forEach { targetString in
            let range = (fullText as NSString).range(of: String(targetString))
            attributedString.addAttribute(.foregroundColor, value: Constant.Color.accent, range: range)
        }

        attributedText = attributedString
    }

}
