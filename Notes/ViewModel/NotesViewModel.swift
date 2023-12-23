//
//  NotesViewModel.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import Foundation

@Observable final class NotesViewModel {
    var notes: [Note]
    
    init(notes: [Note] = []) {
        self.notes = notes
    }
    
    func createNoteWith(title: String, description: String) {
        let note = Note(title: title, description: description, createdAt: .now, updatedAt: .now)
        notes.append(note)
    }
    
    func updateNoteWith(id: UUID, title: String, description: String) {
        if let noteIndex = notes.firstIndex(where: { $0.id == id }) {
            let updatedNote = Note(title: title, description: description, createdAt: notes[noteIndex].createdAt, updatedAt: .now)
            notes[noteIndex] = updatedNote
        }
    }
    
    func removeNoteWith(id: UUID) {
        notes.removeAll { $0.id == id }
    }
}
