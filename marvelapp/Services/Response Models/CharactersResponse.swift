//
//  CharactersResponse.swift
//  marvelapp
//
//  Created by Steven Spry on 3/11/25.
//

import Foundation

struct CharactersResponse: Decodable {
    var code:Int
    var status:String
    var copyright:String
    var attributionText:String
    var attributionHTML:String
    var etag:String
    var data:CharactersData
}

struct CharactersData: Decodable {
    var offset:Int
    var limit:Int
    var total:Int
    var count:Int
    var results:[Character]
}
