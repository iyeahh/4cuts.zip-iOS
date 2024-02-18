//
//  UserDefaultsManager.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation

@propertyWrapper
private struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    enum Key: String {
        case token
        case refreshToken
    }

    @UserDefault(key: Key.token.rawValue, defaultValue: "토큰 없음")
    static var token

    @UserDefault(key: Key.refreshToken.rawValue, defaultValue: "리프레시 토큰 없음")
    static var refreshToken

    static func removeAll() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
