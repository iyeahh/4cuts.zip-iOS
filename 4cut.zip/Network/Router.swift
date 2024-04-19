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
    case uploadPhoto
    case postContent(content: Content)
    case editPost(id: String, content: Content)
    case removePost(id: String)
}

extension Router: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .validPay, .uploadPhoto, .postContent:
            return .post
        case .fetchPostContent, .refresh, .fetchShopping, .map:
            return .get
        case .editPost:
            return .put
        case .removePost:
            return .delete
        }
    }

    var parameters: String? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .login, .refresh, .validPay, .uploadPhoto, .postContent, .editPost, .removePost:
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
        case .fetchPostContent, .refresh, .fetchShopping, .map, .uploadPhoto, .removePost:
            return nil
        case .postContent(let content), .editPost( _, let content):
            let encoder = JSONEncoder()
            return try? encoder.encode(content)
        }
    }

    var baseURL: String {
        switch self {
        case .login, .refresh, .fetchPostContent, .fetchShopping, .validPay, .uploadPhoto, .postContent, .editPost, .removePost:
            return APIKey.baseURL + "v1"
        case .map:
            return APIKey.mapBaseURL + "v2"
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .fetchPostContent, .fetchShopping, .postContent:
            return "/posts"
        case .refresh:
            return "/auth/refresh"
        case .validPay:
            return "/payments/validation"
        case .map:
            return "/local/search/keyword"
        case .uploadPhoto:
            return "/posts/files"
        case .editPost(let id, _), .removePost(let id):
            return "/posts/\(id)"
        }
    }

    var header: [String: String] {
        switch self {
        case .login, .validPay:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        case .fetchPostContent, .fetchShopping, .postContent, .editPost:
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
        case .uploadPhoto:
            return [
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey,
                Header.authorization.rawValue: UserDefaultsManager.token
            ]
        case .removePost:
            return [
                Header.sesacKey.rawValue: APIKey.sesacKey,
                Header.authorization.rawValue: UserDefaultsManager.token
            ]
        }
    }
}
