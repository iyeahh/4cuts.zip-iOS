//
//  PostContentModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import Foundation

struct PostContentModel: Decodable {
    let data: [PostContent]
}

struct PostContent: Decodable {
    let post_id: String
    let title: String?
    let price: Int?
    let content: String?
    let createdAt: String
    let creator: Creator
    let files: [String]
    let comments: [Comment]?
}

struct Creator: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String
}

struct Comment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}
