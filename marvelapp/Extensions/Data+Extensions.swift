//
//  Data+Extensions.swift
//  marvelapp
//
//  Created by Steven Spry on 3/17/25.
//

import Foundation

extension Data {
    func printableJson() -> String {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted,.withoutEscapingSlashes])
            guard let jsonString = String(data: data, encoding: .utf8) else {
                return "Invalid data"
            }
            return jsonString
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}
