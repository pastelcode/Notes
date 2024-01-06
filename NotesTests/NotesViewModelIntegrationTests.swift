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
        // Put setup code here. This method is called before the invocation of each test method in
        // the class.
        ServiceContainer.clear()
        ServiceContainer.register(
            type: NotesDatabaseProtocol.self,
            using: NotesDatabase(inMemory: true)
        )
        ServiceContainer.register(type: CreateNoteUseCase.self, using: CreateNoteUseCase())
        ServiceContainer.register(type: FetchAllNotesUseCase.self, using: FetchAllNotesUseCase())
        ServiceContainer.register(type: UpdateNoteUseCase.self, using: UpdateNoteUseCase())
        ServiceContainer.register(type: RemoveNoteUseCase.self, using: RemoveNoteUseCase())
        sut = .init()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method
        // in the class.
        ServiceContainer.clear()
    }

    func testCreateNote() {
        // Given
        let title = "Test Title"
        let content = "Test Description"
        let iconName = "person.bubble"
        sut.createNoteWith(title: title, content: content, iconName: iconName)

        // When
        let note = self.sut.notes.first

        // Then
        XCTAssertNotNil(note, "Note must exist")
        XCTAssertEqual(note?.title, title)
        XCTAssertEqual(note?.content, content)
        XCTAssertEqual(note?.iconName, iconName)
        XCTAssertEqual(sut.notes.count, 1, "Must be only 1 note created in the database")
    }

    func testCreateTwoNotes() {
        // Given
        let title1 = "Test Title 1"
        let content1 = "Test Content 1"
        let iconName1 = "person.bubble"
        let title2 = "Test Title 2"
        let content2 = "Test Content 2"
        let iconName2 = "person.bubble.fill"
        sut.createNoteWith(title: title1, content: content1, iconName: iconName1)
        sut.createNoteWith(title: title2, content: content2, iconName: iconName2)

        // When
        let firstNote = sut.notes.first
        let secondNote = sut.notes.last

        // Then
        XCTAssertEqual(sut.notes.count, 2, "Must be only 2 notes created in the database")
        XCTAssertNotNil(firstNote, "First note must exist")
        XCTAssertEqual(firstNote?.title, title1)
        XCTAssertEqual(firstNote?.content, content1)
        XCTAssertEqual(firstNote?.iconName, iconName1)
        XCTAssertNotNil(secondNote, "Last note must exist")
        XCTAssertEqual(secondNote?.title, title2)
        XCTAssertEqual(secondNote?.content, content2)
        XCTAssertEqual(secondNote?.iconName, iconName2)
    }

    func testFetchAllNotes() {
        // Given
        let title1 = "Test Title 1"
        let content1 = "Test Content 1"
        let iconName1 = "person.bubble"
        let title2 = "Test Title 2"
        let content2 = "Test Content 2"
        let iconName2 = "person.bubble.fill"
        sut.createNoteWith(title: title1, content: content1, iconName: iconName1)
        sut.createNoteWith(title: title2, content: content2, iconName: iconName2)

        // When
        let firstNote = sut.notes[0]
        let secondNote = sut.notes[1]

        // Then
        XCTAssertEqual(sut.notes.count, 2, "Must be only 2 notes created in the database")
        XCTAssertEqual(firstNote.title, title1)
        XCTAssertEqual(firstNote.content, content1)
        XCTAssertEqual(firstNote.iconName, iconName1)
        XCTAssertEqual(secondNote.title, title2)
        XCTAssertEqual(secondNote.content, content2)
        XCTAssertEqual(secondNote.iconName, iconName2)
    }

    func testUpdateNote() {
        // Given
        let title = "Test Title"
        let content = "Test Content"
        let iconName = "person.bubble"
        sut.createNoteWith(title: title, content: content, iconName: iconName)

        let newTitle = "New Test Title"
        let newContent = "New Test Content"
        let newIconName = "person.bubble.fill"

        // When
        if let identifier = sut.notes.first?.identifier {
            sut.updateNoteWith(
                identifier: identifier,
                title: newTitle,
                content: newContent,
                iconName: newIconName
            )
        } else {
            XCTFail("No note was created.")
        }

        // Then
        XCTAssertEqual(sut.notes.count, 1)
        XCTAssertEqual(sut.notes.first?.title, newTitle)
        XCTAssertEqual(sut.notes.first?.content, newContent)
        XCTAssertEqual(sut.notes.first?.iconName, newIconName)
    }

    func testRemoveNote() {
        // Given
        let title = "Test Title"
        let content = "Test Content"
        let iconName = "person.bubble"
        sut.createNoteWith(title: title, content: content, iconName: iconName)

        // When
        if let identifier = sut.notes.first?.identifier {
            sut.removeNoteWith(identifier: identifier)
        } else {
            XCTFail("No note was created.")
        }

        // Then
        XCTAssertEqual(sut.notes.count, 0)
    }
}
