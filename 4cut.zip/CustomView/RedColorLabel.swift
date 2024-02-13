//
//  RedColorLabel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit

class RedColorLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .red
        font = .systemFont(ofSize: 10)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
