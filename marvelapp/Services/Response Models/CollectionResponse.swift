//
//  CollectionResponse.swift
//  marvelapp
//
//  Created by Steven Spry on 3/12/25.
//

import Foundation

struct CollectionResponse: Decodable {
    var code:Int
    var status:String
    var copyright:String
    var attributionText:String
    var attributionHTML:String
    var etag:String
    var data:CollectionData
}

struct CollectionData: Decodable {
    var offset:Int
    var limit:Int
    var total:Int
    var count:Int
    var results:[CollectionThumbnail]
}

