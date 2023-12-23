//
//  FetchAllNotesUseCase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/23/23.
//

import Foundation

struct FetchAllNotesUseCase {
    var notesDataBase: NotesDatabaseProtocol
    
    init(notesDataBase: NotesDatabaseProtocol = NotesDatabase.shared) {
        self.notesDataBase = notesDataBase
    }
    
    func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note] {
        try notesDataBase.fetchAll(sortBy: sortBy)
    }
}
