//
//  Button+.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import UIKit

@available (iOS 15.0, *)
extension UIButton.Configuration {
    static func category(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.titleAlignment = .center
        configuration.titlePadding = 20
        configuration.baseBackgroundColor = Constant.Color.secondaryLightPink
        configuration.baseForegroundColor = .darkGray
        configuration.cornerStyle = .capsule
        return configuration
    }
}
