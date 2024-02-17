//
//  UIView+.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/25/24.
//

import UIKit

extension UIView: ReuseIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
