//
//  ShoppingModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import Foundation

struct ShoppingModel: Decodable {
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}
