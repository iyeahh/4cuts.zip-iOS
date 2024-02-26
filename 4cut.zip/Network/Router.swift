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
    case fetchShopping(query: String)
    case refresh
}

extension Router: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .fetchPostContent, .refresh, .fetchShopping:
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
            return [URLQueryItem(name: "product_id", value: category.productId),
                    URLQueryItem(name: "limit", value: "10")]
        case .fetchShopping(query: let query):
            return [URLQueryItem(name: "query", value: query)]
        }
    }

    var body: Data? {
        switch self {
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .fetchPostContent, .refresh, .fetchShopping:
            return nil
        }
    }

    var baseURL: String {
        switch self {
        case .login, .refresh, .fetchPostContent:
            return APIKey.baseURL + "v1"
        case .fetchShopping(let query):
            return APIKey.searchNaver + "v1"
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .fetchPostContent:
            return "/posts"
        case .refresh:
            return "/auth/refresh"
        case .fetchShopping:
            return "/search/shop.json"
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
        case .fetchShopping(query: let query):
            return [
                Header.clientID.rawValue: APIKey.naverClientID,
                Header.clientSceret.rawValue: APIKey.naverClientSecretKey
            ]
        }
    }
}
