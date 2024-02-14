//
//  LoginModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation

struct LoginModel: Decodable {
    let id: String
    let email: String
    let nick: String
    let profile: String?
    let access: String
    let refresh: String

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email, nick
        case profile = "profileImage"
        case access = "accessToken"
        case refresh = "refreshToken"
    }
}
