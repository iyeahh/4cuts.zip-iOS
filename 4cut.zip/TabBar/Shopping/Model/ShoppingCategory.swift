//
//  ShoppingCategory.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/29/24.
//

import Foundation

enum ShoppingCategory: CaseIterable {
    case album
    case frame

    var query: String {
        switch self {
        case .album:
            return "4cut_album"
        case .frame:
            return "4cut_frame"
        }
    }
}
