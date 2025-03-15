//
//  DateFormatter+Style.swift
//  marvelapp
//
//  Created by Steven Spry on 3/11/25.
//

import Foundation

extension DateFormatter {
    static func marvel() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }
}
