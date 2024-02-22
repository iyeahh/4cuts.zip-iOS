//
//  PhotoModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/27/24.
//

import Foundation

struct PhotoModel: Hashable, Identifiable {
    let id = UUID()
    let photo: String
    let astio: CGFloat
}
