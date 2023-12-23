//
//  CreateNoteUseCase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/23/23.
//

import Foundation

struct CreateNoteUseCase {
    var notesDataBase: NotesDatabaseProtocol
    
    init(notesDataBase: NotesDatabaseProtocol = NotesDatabase.shared) {
        self.notesDataBase = notesDataBase
    }
    
    func createNoteWith(title: String, content: String) throws {
        let note = Note(title: title, content: content, createdAt: .now, updatedAt: .now)
        try notesDataBase.insert(note: note)
    }
}
