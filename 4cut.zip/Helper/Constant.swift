//
//  Constant.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit

enum Constant {
    enum Login {
        static let emailPlaceholder = "이메일을 입력해주세요"
        static let passwordPlaceholder = "비밀번호를 입력해주세요"
        static let buttonTitle = "로그인"
    }

    enum Color {
        static let accent = UIColor(hex: 0xEF3167)
        static let secondaryPink = UIColor(hex: 0xFEACC4)
        static let secondaryLightPink = UIColor(hex: 0xFEDADF)
    }

    enum Default {
        static let location = (37.358647, 127.105207)
    }
}
