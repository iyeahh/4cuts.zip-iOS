//
//  String+.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import Foundation

extension String {

    var url: URL? {
        return URL(string: APIKey.baseURL + "v1/" + self)
    }

}
