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
        let content = "Test Description"
        let createdAt = Date.now
        let updatedAt = Date.now
        
        // When or Act
        let note = Note(title: title, content: content, createdAt: createdAt, updatedAt: updatedAt)
        
        // Then or Assert
        XCTAssertEqual(title, note.title)
        XCTAssertEqual(content, note.content)
        XCTAssertEqual(createdAt, note.createdAt)
        XCTAssertEqual(updatedAt, note.updatedAt)
    }
    
    func testNoteWithEmptyDescriptionInitialization() {
        let title = "Test Title"
        let createdAt = Date.now
        let updatedAt = Date.now
        
        let note = Note(title: title, createdAt: createdAt, updatedAt: updatedAt)
        
        XCTAssertEqual(title, note.title)
        XCTAssertEqual("", note.content)
        XCTAssertEqual(createdAt, note.createdAt)
        XCTAssertEqual(updatedAt, note.updatedAt)
    }
}
