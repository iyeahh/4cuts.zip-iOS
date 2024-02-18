//
//  DateFormatterManager.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()

    private init() {}

    static let dateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()

    func dateFormat(_ date: String) -> String {
        let dateFormatter = DateFormatterManager.dateFormatter
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        guard let convertDate = dateFormatter.date(from: date) else { return ""}

        let myDateFormatter = DateFormatterManager.dateFormatter
        myDateFormatter.dateFormat = "yyyy년 M월 d일 게시됨"
        return myDateFormatter.string(from: convertDate)
    }
}
