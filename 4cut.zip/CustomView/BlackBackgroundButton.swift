//
//  BlackBackgroundButton.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit

class BlackBackgroundButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = 10
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
