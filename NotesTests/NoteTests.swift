//
//  NotesTests.swift
//  NotesTests
//
//  Created by Samuel Marroquín on 12/22/23.
//

import XCTest
@testable import Notes

final class NoteTests: XCTestCase {
  @MainActor override func setUpWithError() throws {
    let _ = NotesDatabase(inMemory: true)
  }

  func testNoteInitialization() {
    // Given or Arrange
    let title = "Test Title"
    let content = "Test Description"
    let iconName = "person.bubble"
    let createdAt = Date.now
    let updatedAt = Date.now

    // When or Act
    let note = Note(
      title: title,
      content: content,
      iconName: iconName,
      createdAt: createdAt,
      updatedAt: updatedAt
    )

    // Then or Assert
    XCTAssertEqual(note.title, title)
    XCTAssertEqual(note.content, content)
    XCTAssertEqual(note.iconName, iconName)
    XCTAssertEqual(note.createdAt, createdAt)
    XCTAssertEqual(note.updatedAt, updatedAt)
  }

  func testNoteWithEmptyDescriptionInitialization() {
    let title = "Test Title"
    let iconName = "person.bubble"
    let createdAt = Date.now
    let updatedAt = Date.now

    let note = Note(title: title, iconName: iconName, createdAt: createdAt, updatedAt: updatedAt)

    XCTAssertEqual(note.title, title)
    XCTAssertEqual(note.content, "")
    XCTAssertEqual(note.iconName, iconName)
    XCTAssertEqual(note.createdAt, createdAt)
    XCTAssertEqual(note.updatedAt, updatedAt)
  }
}
