//
//  BlackBorderTextField.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit

class BlackBorderTextField: UITextField {

    init(placeholderText: String) {
        super.init(frame: .zero)

        textColor = .black
        placeholder = placeholderText
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
