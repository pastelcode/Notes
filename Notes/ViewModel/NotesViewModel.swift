//
//  NotesViewModel.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import Foundation

@Observable final class NotesViewModel {
    var notes: [Note]
    var sortNotesBy: KeyPath<Note, Date> = \.createdAt
    
    let createNoteUseCase: CreateNoteUseCase
    let fetchAllNotesUseCase: FetchAllNotesUseCase
    
    init(notes: [Note] = [], createNoteUseCase: CreateNoteUseCase = .init(), fetchAllNotesUseCase: FetchAllNotesUseCase = .init()) {
        self.notes = notes
        self.createNoteUseCase = createNoteUseCase
        self.fetchAllNotesUseCase = fetchAllNotesUseCase
        fetchAllNotes()
    }
    
    func createNoteWith(title: String, content: String) {
        do {
            try createNoteUseCase.createNoteWith(title: title, content: content)
            fetchAllNotes()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchAllNotes() {
        do {
            notes = try fetchAllNotesUseCase.fetchAll(sortBy: sortNotesBy)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func updateNoteWith(identifier: UUID, title: String, content: String) {
        if let noteIndex = notes.firstIndex(where: { $0.identifier == identifier }) {
            let updatedNote = Note(title: title, content: content, createdAt: notes[noteIndex].createdAt, updatedAt: .now)
            notes[noteIndex] = updatedNote
        }
    }
    
    func removeNoteWith(identifier: UUID) {
        notes.removeAll { $0.identifier == identifier }
    }
}
