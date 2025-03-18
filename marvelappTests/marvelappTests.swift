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
        let (characters, _,_) = try await self.service.characters()
        XCTAssertGreaterThan(characters.count, 1)
    }
    
    func testCharacterMock() async throws {
        self.service.isMocked = true
        let (characters, _,_) = try await self.service.characters()
        self.service.isMocked = false
        XCTAssertGreaterThan(characters.count, 1)
    }
    
    func testCharacterThumbnail() async throws {
        let character = Character.mock()
        let characterThumbnail = try await MarvelService.shared.thumbnailImage(from: character.thumbnail)
        XCTAssertNotNil(characterThumbnail, "No Character Thumbnail")
    }
    
    func testComicCollection() async throws {
        let (comicThumbnails,_) = try await MarvelService.shared.collection(collectionURI: Character.mock().comics.collectionURI)
        XCTAssertGreaterThan(comicThumbnails.count, 0)
    }
    
    func testEventCollection() async throws {
        let (eventThumbnails,_) = try await MarvelService.shared.collection(collectionURI: Character.mock().events.collectionURI)
        XCTAssertGreaterThan(eventThumbnails.count, 0)
    }
    
    func testCharacterView() async {
        let view = await CharacterView()
        XCTAssertNotNil(view, "Character view failed")
    }
    
    func testCharacterViewModel() async {
        let success = try? await CharacterViewModel().loadCharacters()
        XCTAssertNotNil(success, "Character load failed")
    }
    
    func testCharacterViewModelLoadMore() async {
        let success = try? await CharacterViewModel().loadNextCharacters()
        XCTAssertNotNil(success, "Character load next failed")
    }
    
    func testCharacterDetailView() async {
        let view = await CharacterDetailView(character: Character.mock())
        XCTAssertNotNil(view, "Character detail view failed")
    }
    
    func testCharacterDetailViewModel() async {
        let success = try? await CharacterDetailViewModel().loadCharacterDetails(character: Character.mock())
        XCTAssertNotNil(success, "Character detail load failed")
    }
    
    func testTruncationBelowLimit() async {
        let input = "Hello world"
        let expected = "Hello world"
        XCTAssertEqual(input.truncate(to: 100, ellipsis: true), expected, "Truncation below limit failed")
    }
    
    func testTruncationAboveLimit() async {
        let input = "Hello world"
        let expected = "Hello wo\u{2026}"
        XCTAssertEqual(input.truncate(to: 8, ellipsis: true), expected, "Truncation above limit failed")
    }

}
