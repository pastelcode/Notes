//
//  NotesViewModelIntegrationTests.swift
//  NotesTests
//
//  Created by Samuel Marroquín on 12/23/23.
//

import XCTest
@testable import Notes

final class NotesViewModelIntegrationTests: XCTestCase {
    // SUT: System Under Test
    var sut: NotesViewModel!
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceContainer.clear()
        ServiceContainer.register(type: NotesDatabaseProtocol.self, using: NotesDatabase(inMemory: true))
        ServiceContainer.register(type: CreateNoteUseCase.self, using: CreateNoteUseCase())
        ServiceContainer.register(type: FetchAllNotesUseCase.self, using: FetchAllNotesUseCase())
        sut = .init()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateNote() {
        // Given
        let title = "Test Title"
        let content = "Test Description"
        sut.createNoteWith(title: title, content: content)
        
        // When
        let note = self.sut.notes.first
        
        // Then
        XCTAssertNotNil(note, "Note must exist")
        XCTAssertEqual(note?.title, title)
        XCTAssertEqual(note?.content, content)
        XCTAssertEqual(sut.notes.count, 1, "Must be only 1 note created in the database")
    }
    
    func testCreateTwoNotes() {
        // Given
        let title1 = "Test Title 1"
        let content1 = "Test Content 1"
        let title2 = "Test Title 2"
        let content2 = "Test Content 2"
        sut.createNoteWith(title: title1, content: content1)
        sut.createNoteWith(title: title2, content: content2)
        
        // When
        let firstNote = sut.notes.first
        let secondNote = sut.notes.last
        
        // Then
        XCTAssertEqual(sut.notes.count, 2, "Must be only 2 notes created in the database")
        XCTAssertNotNil(firstNote, "First note must exist")
        XCTAssertEqual(firstNote?.title, title1)
        XCTAssertEqual(firstNote?.content, content1)
        XCTAssertNotNil(secondNote, "Last note must exist")
        XCTAssertEqual(secondNote?.title, title2)
        XCTAssertEqual(secondNote?.content, content2)
    }
    
    func testFetchAllNotes() {
        // Given
        let title1 = "Test Title 1"
        let content1 = "Test Content 1"
        let title2 = "Test Title 2"
        let content2 = "Test Content 2"
        sut.createNoteWith(title: title1, content: content1)
        sut.createNoteWith(title: title2, content: content2)
        
        // When
        let firstNote = sut.notes[0]
        let secondNote = sut.notes[1]
        
        // Then
        XCTAssertEqual(sut.notes.count, 2, "Must be only 2 notes created in the database")
        XCTAssertEqual(firstNote.title, title1)
        XCTAssertEqual(firstNote.content, content1)
        XCTAssertEqual(secondNote.title, title2)
        XCTAssertEqual(secondNote.content, content2)
    }
}
