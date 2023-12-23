//
//  NotesViewModelTests.swift
//  NotesTests
//
//  Created by Samuel Marroquín on 12/22/23.
//

import XCTest
@testable import Notes

final class NotesViewModelTests: XCTestCase {
    var viewModel: NotesViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = NotesViewModel()
    }
    
    func testCreateNote() {
        // Given
        let title = "Test Title"
        let description = "Test Description"
        let now = Date.now
        
        // When
        viewModel.createNoteWith(title: title, content: description)
        
        // Then
        XCTAssertEqual(viewModel.notes.count, 1)
        XCTAssertEqual(viewModel.notes.first!.title, title)
        XCTAssertEqual(viewModel.notes.first!.content, description)
        XCTAssertEqual(viewModel.notes.first!.createdAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        XCTAssertEqual(viewModel.notes.first!.updatedAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
    }
    
    func testCreateThreeNotes() {
        // Given
        let title1 = "Test Title 1"
        let description1 = "Test Description 1"
        let title2 = "Test Title 2"
        let description2 = "Test Description 2"
        let title3 = "Test Title 3"
        let description3 = "Test Description 3"
        let now = Date.now
        
        // When
        viewModel.createNoteWith(title: title1, content: description1)
        viewModel.createNoteWith(title: title2, content: description2)
        viewModel.createNoteWith(title: title3, content: description3)
        
        // Then
        XCTAssertEqual(viewModel.notes.count, 3)
        
        XCTAssertEqual(viewModel.notes.first!.title, title1)
        XCTAssertEqual(viewModel.notes.first!.content, description1)
        XCTAssertEqual(viewModel.notes.first!.createdAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        XCTAssertEqual(viewModel.notes.first!.updatedAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        
        XCTAssertEqual(viewModel.notes[1].title, title2)
        XCTAssertEqual(viewModel.notes[1].content, description2)
        XCTAssertEqual(viewModel.notes[1].createdAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        XCTAssertEqual(viewModel.notes[1].updatedAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        
        XCTAssertEqual(viewModel.notes[2].title, title3)
        XCTAssertEqual(viewModel.notes[2].content, description3)
        XCTAssertEqual(viewModel.notes[2].createdAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        XCTAssertEqual(viewModel.notes[2].updatedAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
    }
    
    func testUpdateNote() {
        // Given
        let title = "Test Title"
        let description = "Test Description"
        viewModel.createNoteWith(title: title, content: description)
        
        let newTitle = "New Test Title"
        let newDescription = "New Test Description"
        
        // When
        let now = Date.now
        if let identifier = viewModel.notes.first?.identifier {
            viewModel.updateNoteWith(identifier: identifier, title: newTitle, content: newDescription)
        } else {
            XCTFail("No note was created")
        }
        
        // Then
        XCTAssertEqual(viewModel.notes.count, 1)
        XCTAssertEqual(viewModel.notes.first?.title, newTitle)
        XCTAssertEqual(viewModel.notes.first?.content, newDescription)
        XCTAssertEqual(viewModel.notes.first!.updatedAt.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
    }
    
    func testRemoveTest() {
        // Given
        let title = "Test Title"
        let description = "Test Description"
        viewModel.createNoteWith(title: title, content: description)
        
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
