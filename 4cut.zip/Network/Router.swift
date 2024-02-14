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
}

extension Router: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }

    var parameters: String? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var body: Data? {
        switch self {
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }

    var baseURL: String {
        return APIKey.baseURL + "v1"
    }

    var path: String {
        switch self {
        case .login:
            return "/users/login"
        }
    }

    var header: [String: String] {
        switch self {
        case .login:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        }
    }
}
