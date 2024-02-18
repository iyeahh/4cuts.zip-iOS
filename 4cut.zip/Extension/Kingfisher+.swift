//
//  Kingfisher+.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import Foundation
import Kingfisher

extension KingfisherManager {

    func setHeaders() {
            let modifier = AnyModifier { request in
                var req = request
                req.addValue(Header.json.rawValue, forHTTPHeaderField: Header.contentType.rawValue)
                req.addValue(APIKey.sesacKey, forHTTPHeaderField: Header.sesacKey.rawValue)
                req.addValue(UserDefaultsManager.token, forHTTPHeaderField: Header.authorization.rawValue)
                return req
            }

            KingfisherManager.shared.defaultOptions = [
                .requestModifier(modifier)
            ]
        }

}
