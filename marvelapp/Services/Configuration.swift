//
//  Configuration.swift
//  marvelapp
//
//  Created by Steven Spry on 3/14/25.
//

import Foundation

struct Configuration : Decodable {
    let apiKey : String
    let appHash : String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "ApiKey"
        case appHash = "AppHash"
    }
}
