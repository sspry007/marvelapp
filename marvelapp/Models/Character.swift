//
//  Character.swift
//  marvelapp
//
//  Created by Steven Spry on 3/11/25.
//

import Foundation

struct Character: Decodable {
    var id:Int
    var name:String
    var description:String
    var modified:Date
    var thumbnail:Thumbnail
    var resourceURI:String
    var comics: Collection
    var events: Collection
    
    static func mock() -> Character {
        let character = Character(id: 1,
                                  name: "3-D Man",
                                  description: "Vowing to serve his country any way he could, young Steve Rogers took the super soldier serum to bec...",
                                  modified: Date.now,
                                  thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
                                                       fileExtension: "jpg"),
                                  resourceURI: "",
                                  comics: Collection(available: 1, 
                                                     collectionURI: "http://gateway.marvel.com/v1/public/characters/1011334/comics",
                                                     items: [],
                                                     returned: 0),
                                  events: Collection(available: 1, 
                                                     collectionURI: "http://gateway.marvel.com/v1/public/characters/1011334/events",
                                                     items: [],
                                                     returned: 0))
        return character
    }
}

extension Character: Hashable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

