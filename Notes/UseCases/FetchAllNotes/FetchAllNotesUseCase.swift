//
//  FetchAllNotesUseCase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/23/23.
//

import Foundation

struct FetchAllNotesUseCase: FetchAllNotesProtocol {
    let database: NotesDatabaseProtocol
    
    func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note] {
        try database.fetchAll(sortBy: sortBy)
    }
}
