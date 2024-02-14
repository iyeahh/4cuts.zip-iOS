//
//  TargetType.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL() // URL 만들어줌
        var request = try URLRequest(url: url.appendingPathComponent(path), method: method)
        request.allHTTPHeaderFields = header
        request.httpBody = body
        return request
    }
}
