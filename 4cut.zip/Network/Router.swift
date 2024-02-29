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
    case validPay(query: PaymentValidation)
    case refresh
    case map(x: Double, y: Double)
}

extension Router: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .validPay:
            return .post
        case .fetchPostContent, .refresh, .fetchShopping, .map:
            return .get
        }
    }

    var parameters: String? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .login, .refresh, .validPay:
            return nil
        case .fetchPostContent(let category):
            return [URLQueryItem(name: "product_id", value: category.productId),
                    URLQueryItem(name: "limit", value: "10")]
        case .fetchShopping(let query):
            return [URLQueryItem(name: "product_id", value: query),
                    URLQueryItem(name: "limit", value: "10")]
        case .map(let x, let y):
            return [URLQueryItem(name: "query", value: "근처 즉석사진"),
                    URLQueryItem(name: "x", value: "\(x)"),
                    URLQueryItem(name: "y", value: "\(y)")
            ]
        }
    }

    var body: Data? {
        switch self {
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .validPay(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .fetchPostContent, .refresh, .fetchShopping, .map:
            return nil
        }
    }

    var baseURL: String {
        switch self {
        case .login, .refresh, .fetchPostContent, .fetchShopping, .validPay:
            return APIKey.baseURL + "v1"
        case .map:
            return APIKey.mapBaseURL + "v2"
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .fetchPostContent, .fetchShopping:
            return "/posts"
        case .refresh:
            return "/auth/refresh"
        case .validPay:
            return "/payments/validation"
        case .map:
            return "/local/search/keyword"
        }
    }

    var header: [String: String] {
        switch self {
        case .login, .validPay:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        case .fetchPostContent, .fetchShopping:
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
        case .map:
            return [
                Header.authorization.rawValue: APIKey.kakaoKey
            ]
        }
    }
}
