//
//  NotesTests.swift
//  NotesTests
//
//  Created by Samuel Marroquín on 12/22/23.
//

import XCTest
@testable import Notes

final class NoteTests: XCTestCase {
    func testNoteInitialization() {
        // Given or Arrange
        let title = "Test Title"
        let description = "Test Description"
        let createdAt = Date.now
        let updatedAt = Date.now
        
        // When or Act
        let note = Note(title: title, description: description, createdAt: createdAt, updatedAt: updatedAt)
        
        // Then or Assert
        XCTAssertEqual(title, note.title)
        XCTAssertEqual(description, note.description)
        XCTAssertEqual(createdAt, note.createdAt)
        XCTAssertEqual(updatedAt, note.updatedAt)
    }
    
    func testNoteWithEmptyDescriptionInitialization() {
        let title = "Test Title"
        let createdAt = Date.now
        let updatedAt = Date.now
        
        let note = Note(title: title, createdAt: createdAt, updatedAt: updatedAt)
        
        XCTAssertEqual(title, note.title)
        XCTAssertEqual("", note.description)
        XCTAssertEqual(createdAt, note.createdAt)
        XCTAssertEqual(updatedAt, note.updatedAt)
    }
}
