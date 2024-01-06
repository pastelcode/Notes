//
//  RemoveNoteUseCase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/29/23.
//

import Foundation

struct RemoveNoteUseCase {
    @Service private var database: NotesDatabaseProtocol

    func removeNoteWith(identifier: UUID) throws {
        try database.removeWith(identifier: identifier)
    }
}
