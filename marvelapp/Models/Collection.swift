//
//  Collection.swift
//  marvelapp
//
//  Created by Steven Spry on 3/11/25.
//

import Foundation

struct Collection: Decodable {
    var available:Int
    var collectionURI:String
    var items:[CollectionItem]
    var returned:Int
}
