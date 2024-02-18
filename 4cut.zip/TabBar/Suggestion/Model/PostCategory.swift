//
//  PostCategory.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import Foundation

enum PostCategory {
    case new
    case background
    case pose

    var title: String {
        switch self {
        case .new:
            return "New포토부스 ✨"
        case .background:
            return "배경/필터 🫧"
        case .pose:
            return "포즈 🫶🏻"
        }
    }

    var productId: String {
        switch self {
        case .new:
            return "4cut_new"
        case .background:
            return "4cut_booth"
        case .pose:
            return "4cut_pose"
        }
    }
}
