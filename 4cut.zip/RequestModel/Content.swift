//
//  Content.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/31/24.
//

import Foundation

struct Content: Encodable {
    let content: String
    let product_id: String
    let files: [String]
}
