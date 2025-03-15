//
//  String+Extensions.swift
//  marvelapp
//
//  Created by Steven Spry on 3/13/25.
//

import Foundation

extension String {
    func truncate(to limit: Int, ellipsis: Bool = true) -> String {
        if count > limit {
            let truncated = String(prefix(limit)).trimmingCharacters(in: .whitespacesAndNewlines)
            return ellipsis ? truncated + "\u{2026}" : truncated
        } else {
            return self
        }
    }
    
    func log() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSxxxx"
        let formattedNow = formatter.string(from: Date.now)
        print("\(formattedNow)\t\(self)")
    }
}
