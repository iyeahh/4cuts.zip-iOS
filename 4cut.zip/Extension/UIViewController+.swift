//
//  UIViewController+.swift
//  4cut.zip
//
//  Created by Bora Yang on 9/1/24.
//

import UIKit
import Toast

extension UIViewController {
    
    func makeToast(title: String, message: String) {
        var style = ToastStyle()
        style.titleAlignment = .center
        style.messageAlignment = .center
        style.titleColor = Constant.Color.accent
        style.backgroundColor = Constant.Color.secondaryLightPink
        style.messageColor = .white
        style.titleFont = .boldSystemFont(ofSize: 14)
        style.messageFont = .systemFont(ofSize: 13)
        self.view.makeToast(message, duration: 3.0, title: title, style: style)
    }

}
