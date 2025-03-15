//
//  Thumbnail.swift
//  marvelapp
//
//  Created by Steven Spry on 3/11/25.
//

import Foundation

struct Thumbnail: Decodable {
    var path: String
    var fileExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
    
    var urlString: String {
        return "\(path)/standard_fantastic.\(fileExtension)"
    }
}
