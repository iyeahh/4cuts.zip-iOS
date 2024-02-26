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

    var makeInt: String? {
        guard let intString = Int(self) else { return nil }
        return "\(intString.formatted())원"
    }

    var makeOnlyString: String {
        let str = self.replacingOccurrences(of: "<b>", with: "")
        return str.replacingOccurrences(of: "</b>", with: "")
    }

}
