//
//  CharacterDetailViewModel.swift
//  marvelapp
//
//  Created by Steven Spry on 3/13/25.
//

import Foundation

class CharacterDetailViewModel: ObservableObject {
    @Published var comicThumbnails: [CollectionThumbnail] = []
    @Published var eventThumbnails: [CollectionThumbnail] = []
    @Published var comicAttribution: String = ""
    @Published var eventAttribution: String = ""
    @Published var isLoading: Bool = false

    func loadCharacterDetails(character: Character) async throws -> Bool {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        do {
            let (comicThumbnails,attribution) = try await MarvelService.shared.collection(collectionURI: character.comics.collectionURI)
            DispatchQueue.main.async {
                self.comicThumbnails = comicThumbnails
                self.comicAttribution = attribution
                dispatchGroup.leave()
            }
        } catch let error {
            print(error)
            dispatchGroup.leave()
            throw error
        }
        
        dispatchGroup.enter()
        do {
            let (eventThumbnails,attribution) = try await MarvelService.shared.collection(collectionURI: character.events.collectionURI)
            DispatchQueue.main.async {
                self.eventThumbnails = eventThumbnails
                self.eventAttribution = attribution
                dispatchGroup.leave()
            }
        } catch let error {
            print(error)
            dispatchGroup.leave()
            throw error
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
        }
        return true
    }
}
