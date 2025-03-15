//
//  CharacterViewModel.swift
//  marvelapp
//
//  Created by Steven Spry on 3/11/25.
//

import SwiftUI

class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var attribution: String = ""
    @Published var isConnected = false

    private var offset = 0
    private var limit = 21
    private var total = 0
    let itemWidth = UIScreen.main.bounds.size.width / 3.0

    func loadCharacters() async {
        do {
            let (characters, total, attribution) = try await MarvelService.shared.characters()
            DispatchQueue.main.async {
                self.total = total
                self.characters = characters
                self.isConnected = true
                self.attribution = attribution
            }
        } catch let error {
            print(error)
            DispatchQueue.main.async {
                self.isConnected = false
            }
        }
    }
    
    func loadNextCharacters() async {
        guard offset < total else { return }
        
        do {
            self.offset += limit
            let (characters, total, attribution) = try await MarvelService.shared.characters(offset: offset)
            DispatchQueue.main.async {
                self.total = total
                self.characters.append(contentsOf: characters)
                self.attribution = attribution
            }
        } catch let error {
            print(error)
        }
    }
}
