//
//  marvelappTests.swift
//  marvelappTests
//
//  Created by Steven Spry on 3/10/25.
//

import XCTest
@testable import marvelapp

final class marvelappTests: XCTestCase {

    fileprivate var service : MarvelService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.service = MarvelService.shared
    }

    override func tearDownWithError() throws {
        self.service = nil
        try super.tearDownWithError()
    }
    
    func testCharacterConnection() async throws {
        let (characters, total,_) = try await self.service.characters()
        XCTAssertGreaterThan(characters.count, 1)
    }
    
    func testCharacterThumbnail() async throws {
        let character = Character.mock()
        let characterThumbnail = try await MarvelService.shared.thumbnailImage(from: character.thumbnail)
        XCTAssertNotNil(characterThumbnail)
    }
    
    func testComicCollection() async throws {
        let (comicThumbnails,_) = try await MarvelService.shared.collection(collectionURI: Character.mock().comics.collectionURI)
        XCTAssertGreaterThan(comicThumbnails.count, 0)
    }
    
    func testEventCollection() async throws {
        let (eventThumbnails,_) = try await MarvelService.shared.collection(collectionURI: Character.mock().events.collectionURI)
        XCTAssertGreaterThan(eventThumbnails.count, 0)
    }

}
