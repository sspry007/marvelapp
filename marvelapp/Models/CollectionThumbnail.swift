//
//  CollectionThumbnail.swift
//  marvelapp
//
//  Created by Steven Spry on 3/12/25.
//

import Foundation

struct CollectionThumbnail: Decodable {
    var id:Int
    var title:String
    var thumbnail:Thumbnail
}

extension CollectionThumbnail: Hashable {
    static func == (lhs: CollectionThumbnail, rhs: CollectionThumbnail) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

