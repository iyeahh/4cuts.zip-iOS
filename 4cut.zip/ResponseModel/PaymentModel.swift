//
//  PaymentModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/29/24.
//

import Foundation

struct PaymentModel: Decodable {
    let buyer_id: String?
    let post_id: String?
    let merchant_uid: String?
    let productName: String?
    let price: Int?
    let paidAt: String?
}
