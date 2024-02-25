//
//  Header.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation

enum Header: String {
    case authorization = "Authorization"
    case sesacKey = "SesacKey"
    case refresh = "Refresh"
    case contentType = "Content-Type"
    case json = "application/json"
    case multipart = "multipart/form-data"
    case clientID = "X-Naver-Client-Id"
    case clientSceret = "X-Naver-Client-Secret"
}
