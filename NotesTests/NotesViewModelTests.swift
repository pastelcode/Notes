//
//  NotesViewModelTests.swift
//  NotesTests
//
//  Created by Samuel Marroquín on 12/22/23.
//

import XCTest
@testable import Notes

var notesDatabase: [Note] = []

struct CreateNoteUseCaseMock: CreateNoteProtocol {
    func createNoteWith(title: String, content: String, iconName: String) throws {
        let note = Note(
            title: title,
            content: content,
            iconName: iconName,
            createdAt: .now,
            updatedAt: .now
        )
        notesDatabase.append(note)
    }
}

struct FetchAllNotesUseCaseMock: FetchAllNotesProtocol {
    func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note] {
        notesDatabase
    }
}

struct UpdateNoteUseCaseMock: UpdateNoteProtocol {
    func updateNoteWith(identifier: UUID, title: String, content: String, iconName: String) throws {
        if let note = notesDatabase.first(where: { $0.identifier == identifier }) {
            note.title = title
            note.content = content
            note.iconName = iconName
            note.updatedAt = .now
        }
    }
}

struct RemoveNoteUseCaseMock: RemoveNoteProtocol {
    func removeNoteWith(identifier: UUID) throws {
        notesDatabase.removeAll { $0.identifier == identifier }
    }
}

final class NotesViewModelTests: XCTestCase {
    var viewModel: NotesViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in
        // the class.
        viewModel = NotesViewModel(
            createNoteUseCase: CreateNoteUseCaseMock(),
            fetchAllNotesUseCase: FetchAllNotesUseCaseMock(),
            updateNoteUseCase: UpdateNoteUseCaseMock(),
            removeNoteUseCase: RemoveNoteUseCaseMock()
        )
    }

    override func tearDownWithError() throws {
        notesDatabase.removeAll()
    }

    func testCreateNote() {
        // Given
        let title = "Test Title"
        let description = "Test Description"
        let iconName = "person.bubble"
        let now = Date.now

        // When
        viewModel.createNoteWith(title: title, content: description, iconName: iconName)

        // Then
        XCTAssertEqual(viewModel.notes.count, 1)
        XCTAssertEqual(viewModel.notes.first?.title, title)
        XCTAssertEqual(viewModel.notes.first?.content, description)
        XCTAssertEqual(viewModel.notes.first?.iconName, iconName)
        XCTAssertEqual(
            viewModel.notes.first!.createdAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
        XCTAssertEqual(
            viewModel.notes.first!.updatedAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
    }

    func testCreateThreeNotes() {
        // Given
        let title1 = "Test Title 1"
        let description1 = "Test Description 1"
        let iconName1 = "person.bubble"
        let title2 = "Test Title 2"
        let description2 = "Test Description 2"
        let iconName2 = "person.bubble.fill"
        let title3 = "Test Title 3"
        let description3 = "Test Description 3"
        let iconName3 = "bubble.middle.bottom"
        let now = Date.now

        // When
        viewModel.createNoteWith(title: title1, content: description1, iconName: iconName1)
        viewModel.createNoteWith(title: title2, content: description2, iconName: iconName2)
        viewModel.createNoteWith(title: title3, content: description3, iconName: iconName3)

        // Then
        XCTAssertEqual(viewModel.notes.count, 3)

        XCTAssertEqual(viewModel.notes.first?.title, title1)
        XCTAssertEqual(viewModel.notes.first?.content, description1)
        XCTAssertEqual(viewModel.notes.first?.iconName, iconName1)
        XCTAssertEqual(
            viewModel.notes.first!.createdAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
        XCTAssertEqual(
            viewModel.notes.first!.updatedAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )

        XCTAssertEqual(viewModel.notes[1].title, title2)
        XCTAssertEqual(viewModel.notes[1].content, description2)
        XCTAssertEqual(viewModel.notes[1].iconName, iconName2)
        XCTAssertEqual(
            viewModel.notes[1].createdAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
        XCTAssertEqual(
            viewModel.notes[1].updatedAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )

        XCTAssertEqual(viewModel.notes.last?.title, title3)
        XCTAssertEqual(viewModel.notes.last?.content, description3)
        XCTAssertEqual(viewModel.notes.last?.iconName, iconName3)
        XCTAssertEqual(
            viewModel.notes.last!.createdAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
        XCTAssertEqual(
            viewModel.notes.last!.updatedAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
    }

    func testUpdateNote() {
        // Given
        let title = "Test Title"
        let description = "Test Description"
        let iconName = "person.bubble"
        viewModel.createNoteWith(title: title, content: description, iconName: iconName)

        let newTitle = "New Test Title"
        let newDescription = "New Test Description"
        let newIconName = "person.bubble.fill"

        // When
        let now = Date.now
        if let identifier = viewModel.notes.first?.identifier {
            viewModel.updateNoteWith(
                identifier: identifier,
                title: newTitle,
                content: newDescription,
                iconName: newIconName
            )
        } else {
            XCTFail("No note was created")
        }

        // Then
        XCTAssertEqual(viewModel.notes.count, 1)
        XCTAssertEqual(viewModel.notes.first?.title, newTitle)
        XCTAssertEqual(viewModel.notes.first?.content, newDescription)
        XCTAssertEqual(viewModel.notes.first?.iconName, newIconName)
        XCTAssertEqual(
            viewModel.notes.first!.updatedAt.timeIntervalSinceReferenceDate,
            now.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
    }

    func testRemoveTest() {
        // Given
        let title = "Test Title"
        let description = "Test Description"
        let iconName = "person.bubble"
        viewModel.createNoteWith(title: title, content: description, iconName: iconName)

        // When
        if let identifier = viewModel.notes.first?.identifier {
            viewModel.removeNoteWith(identifier: identifier)
        } else {
            XCTFail("No note was created")
        }

        // Then
        XCTAssertTrue(viewModel.notes.isEmpty)
    }
}
