//
//  Router.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation
import Alamofire

enum Router {
    case login(query: LoginQuery)
    case fetchPostContent(category: PostCategory)
    case refresh
}

extension Router: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .fetchPostContent, .refresh:
            return .get
        }
    }

    var parameters: String? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .login, .refresh:
            return nil
        case .fetchPostContent(let category):
            return [URLQueryItem(name: "product_id", value: category.productId)]
        }
    }

    var body: Data? {
        switch self {
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .fetchPostContent, .refresh:
            return nil
        }
    }

    var baseURL: String {
        return APIKey.baseURL + "v1"
    }

    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .fetchPostContent:
            return "/posts"
        case .refresh:
            return "/auth/refresh"
        }
    }

    var header: [String: String] {
        switch self {
        case .login:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        case .fetchPostContent:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey,
                Header.authorization.rawValue: UserDefaultsManager.token
            ]
        case .refresh:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.refresh.rawValue: UserDefaultsManager.refreshToken,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        }
    }
}
