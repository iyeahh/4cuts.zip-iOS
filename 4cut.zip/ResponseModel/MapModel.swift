//
//  MapModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/30/24.
//

import Foundation

struct MapModel: Decodable {
    let documents: [PhotoBooth]
}

struct PhotoBooth: Decodable {
    let place_name: String
    let x: String
    let y: String
}
